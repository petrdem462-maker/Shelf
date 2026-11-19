import Foundation
import Observation

@MainActor
@Observable
final class SearchViewModel {
    enum State {
        case idle, loading, empty
        case loaded([BookSummary])
        case failed(String)
    }
    
    var query = ""
    private(set) var state: State = .idle
    
    private let api: BookAPI
    private var searchTask: Task<Void, Never>?
    
    init(api:BookAPI) {
        self.api = api
    }
    
    func queryChanged() {
        searchTask?.cancel()
        let text = query.trimmingCharacters(in: .whitespaces)
        guard text.count >= 2 else { state = .idle; return}
        
        searchTask = Task {
            try? await Task.sleep(for: .milliseconds(400))
            guard !Task.isCancelled else { return }
            await search(text)
        }
    }
    private func search(_ text: String) async {
        state = .loading
        do {
            let response = try await api.search(text, page: 1)
            guard !Task.isCancelled else { return }
            state = response.docs.isEmpty ? .empty : .loaded(response.docs)
        } catch is CancellationError {
            // user input, ignore it
        } catch let error as URLError where error.code == .cancelled {
            // same, urlsession's vers of cancellation
        } catch {
            state = .failed(error.localizedDescription)
        }
    }
}
