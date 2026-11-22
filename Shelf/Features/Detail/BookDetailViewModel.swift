import Foundation
import Observation

@MainActor
@Observable
final class BookDetailViewModel {
    enum State {
        case loading
        case loaded(WorkDetail, rating: RatingsResponse.Summary?)
        case failed(String)
    }

    let book: BookSummary
    private(set) var state: State = .loading
    private(set) var savedStatus: ReadingStatus?

    private let api: BookAPI
    private let library: LibraryRepository

    init(book: BookSummary, api: BookAPI, library: LibraryRepository) {
        self.book = book
        self.api = api
        self.library = library
    }

    func load() async {
        savedStatus = (try? library.book(id: book.workID))?.status
        async let work = api.work(id: book.workID)
        async let ratings = api.ratings(workID: book.workID)

        do {
            let detail = try await work
            let rating = try? await ratings
            state = .loaded(detail, rating: rating?.summary)
        } catch {
            state = .failed(error.localizedDescription)
        }
    }
    
    func setStatus(_ status: ReadingStatus) {
        try? library.save(book, status: status)
        savedStatus = status
    }
    
    func remove() {
        guard let saved = try? library.book(id: book.workID) else { return }
        try? library.delete(saved)
        savedStatus = nil
    }
}
