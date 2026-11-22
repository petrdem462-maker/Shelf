import SwiftUI
import SwiftData

struct SearchView: View {
    @State private var viewModel: SearchViewModel
    private let api: BookAPI
    private let library: LibraryRepository
    
    init(api: BookAPI, library: LibraryRepository) {
        self.api = api
        self.library = library
        _viewModel = State(initialValue: SearchViewModel(api: api))
    }

    var body: some View {
        content
            .navigationTitle("Search")
            .searchable(text: $viewModel.query, prompt: "Title or author")
            .onChange(of: viewModel.query) { viewModel.queryChanged() }
            .navigationDestination(for: BookSummary.self) { book in
                BookDetailView(book: book, api: api, library: library)
            }
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
            ContentUnavailableView("Something went wrong", systemImage: "wifi.exclamationmark",
                                   description: Text(message))
        case .loaded(let books):
            List(books) { book in
                NavigationLink(value: book) {
                    BookRow(book: book)
                }
            }
        }
    }
}

#Preview {
    let container = try! AppDatabase.makeContainer(inMemory: true)
    NavigationStack {
        SearchView(api: OpenLibraryAPI(client: HTTPClient()), library: LibraryRepository(context: container.mainContext))
    }
    .modelContainer(container)
}
