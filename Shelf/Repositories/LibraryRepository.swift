import Foundation
import SwiftData

@MainActor
final class LibraryRepository {
    private let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    func save(_ summary: BookSummary, status: ReadingStatus) throws {
        if let existing = try book(id: summary.workID) {
            existing.status = status
        } else {
            let book = SavedBook(workID: summary.workID, title: summary.title, author: summary.authorText, coverID: summary.coverID, pageCount: summary.pageCount, status: status)
            context.insert(book)
        }
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
        book.status = status
        try context.save()
    }
    
    func delete(_ book: SavedBook) throws {
        context.delete(book)
        try context.save()
    }
}
