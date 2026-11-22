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

    init(book: BookSummary, api: BookAPI) {
        self.book = book
        self.api = api
    }

    func load() async {
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
}
