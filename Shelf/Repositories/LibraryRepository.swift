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
}
