import SwiftUI

struct SearchView: View {
    @State private var viewModel: SearchViewModel
    
    init(api: BookAPI) {
        _viewModel = State(initialValue: SearchViewModel(api: api))
    }
    
    var body: some View {
        content
            .navigationTitle("Search")
            .searchable(text: $viewModel.query, prompt: "Title or author")
            .onChange(of: viewModel.query) { viewModel.queryChanged()}
    }
    
    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle:
            ContentUnavailableView("Find a book", systemImage: "book",
                                   description: Text("Search by title or author"))
        case .loading:
            ProgressView()
        case .empty:
            ContentUnavailableView.search(text: viewModel.query)
        case .failed(let message):
            ContentUnavailableView("Something went wrong", systemImage: "wifi.exclamationmark", description: Text(message))
        case .loaded(let books):
            List(books) { book in
                BookRow(book: book)
            }
        }
    }
}

#Preview {
    NavigationStack {
        SearchView(api: OpenLibraryAPI(client: HTTPClient()))
    }
}
