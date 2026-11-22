import Foundation
import SwiftData

enum LibraryError: Error {
    case invalidPages
    case tooManyPages
}

@MainActor
final class LibraryRepository {
    private let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    func save(_ summary: BookSummary, status: ReadingStatus) throws {
        let book: SavedBook
        if let existing = try self.book(id: summary.workID) {
            book = existing
        } else {
            book = SavedBook(workID: summary.workID, title: summary.title, author: summary.authorText, coverID: summary.coverID, pageCount: summary.pageCount, status: status)
            context.insert(book)
        }
        setStatus(status, on: book)
        try context.save()
    }
    
    func books(with status: ReadingStatus) throws -> [SavedBook] {
        let raw = status.rawValue
        var descriptor = FetchDescriptor<SavedBook>(
            predicate: #Predicate { $0.statusRaw == raw },
            sortBy: [SortDescriptor(\.addedAt, order: .reverse)])
        descriptor.relationshipKeyPathsForPrefetching = [\.sessions]
        return try context.fetch(descriptor)
    }
    
    func book(id: String) throws -> SavedBook? {
        var descriptor = FetchDescriptor<SavedBook>(
            predicate: #Predicate {$0.workID == id})
        descriptor.fetchLimit = 1
        return try context.fetch(descriptor).first
    }
    
    func updateStatus(of book: SavedBook, to status: ReadingStatus) throws {
        setStatus(status, on: book)
        try context.save()
    }
    
    private func setStatus(_ status: ReadingStatus, on book: SavedBook)  {
        book.status = status
        book.finishedAt = status == .finished ? .now : nil
    }
    
    func delete(_ book: SavedBook) throws {
        context.delete(book)
        try context.save()
    }
    
    func logSession(for book: SavedBook, pages: Int, date: Date = .now) throws {
        guard pages > 0 else {
            throw LibraryError.invalidPages
        }
        
        let session = ReadingSession(date: date, pages: pages)
        context.insert(session)
        session.book = book
        
        if book.pagesLeft == 0 {
            setStatus(.finished, on: book)
        } else if book.status == .wantToRead {
            setStatus(.reading, on: book)
        }
        try context.save()
    }
    
    func stats(now: Date = .now) throws -> Stats {
        let calendar = Calendar.current
        let monthStart = calendar.dateInterval(of: .month, for: now)?.start ?? now
        let yearStart = calendar.dateInterval(of: .year, for: now)?.start ?? now

        let sessions = try context.fetch(FetchDescriptor<ReadingSession>(
            predicate: #Predicate { $0.date >= monthStart }))

        var stats = Stats()

        stats.pagesThisMonth = sessions.reduce(0) { $0 + $1.pages }

        stats.activeDaysThisMonth = Set(sessions.map { calendar.startOfDay(for: $0.date) }).count

        let finishedRaw = ReadingStatus.finished.rawValue
        let finished = try context.fetch(FetchDescriptor<SavedBook>(
            predicate: #Predicate { $0.statusRaw == finishedRaw }))
        stats.finishedThisYear = finished.filter { ($0.finishedAt ?? .distantPast) >= yearStart }.count

        let sessionsWithBook = sessions.filter { $0.book != nil }
        let byBook = Dictionary(grouping: sessionsWithBook) { $0.book! }
        stats.topBooks = Array(
            byBook
                .map { book, bookSessions in
                    (title: book.title, pages: bookSessions.reduce(0) { $0 + $1.pages })
                }
                .sorted { $0.pages > $1.pages }
                .prefix(5)
        )

        return stats
    }
    
    func pagesPerDay(days: Int = 30, now: Date = .now) throws -> [(day: Date, pages: Int)] {
        let calendar = Calendar.current
        let start = calendar.date(byAdding: .day, value: -days, to: calendar.startOfDay(for: now)) ?? now
        let sessions = try context.fetch(FetchDescriptor<ReadingSession>(
            predicate: #Predicate { $0.date >= start }))
        let byDay = Dictionary(grouping: sessions) { calendar.startOfDay(for: $0.date) }
        return byDay
            .map { day, daySessions in (day: day, pages: daySessions.reduce(0) { $0 + $1.pages }) }
            .sorted { $0.day < $1.day }
    }
}
