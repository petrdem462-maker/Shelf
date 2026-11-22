import Foundation
import Observation

@MainActor
@Observable
final class LibraryViewModel {
    var selectedStatus: ReadingStatus = .reading
    private(set) var books: [SavedBook] = []
    
    private let library: LibraryRepository
    
    init(library: LibraryRepository) {
        self.library = library
    }
    
    func load() {
        books = (try? library.books(with: selectedStatus)) ?? []
    }
    
    func delete(_ book: SavedBook) {
        try? library.delete(book)
        load()
    }
}
