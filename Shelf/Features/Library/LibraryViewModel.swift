import Foundation
import Observation

@MainActor
@Observable
final class LibraryViewModel {
    var selectedStatus: ReadingStatus = .reading
    private(set) var books: [SavedBook] = []
    private(set) var ratings: [String: Double] = [:]
    
    private let api: BookAPI
    private let library: LibraryRepository
    
    init(api: BookAPI, library: LibraryRepository) {
        self.library = library
        self.api = api
    }
    
    func load() {
        books = (try? library.books(with: selectedStatus)) ?? []
    }
    
    func delete(_ book: SavedBook) {
        try? library.delete(book)
        load()
    }
    
    func logSession(for book: SavedBook, pages: Int) {
            try? library.logSession(for: book, pages: pages)
            load()
    }
    
    func refreshRatings() async {
        let ids = books.map(\.workID)
        let api = self.api
        
        let fresh = await withTaskGroup(of: (String, Double?).self) {
            group in for id in ids {
                group.addTask {
                    (id, try? await api.ratings(workID: id).summary.average)
                }
            }
            var result: [String: Double] = [:]
            for await (id, average) in group {
                if let average { result[id] = average}
            }
            return result
        }
        ratings = fresh
    }
}
