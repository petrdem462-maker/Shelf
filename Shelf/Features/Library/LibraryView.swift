import SwiftUI
import SwiftData

struct LibraryView: View {
    @State private var viewModel: LibraryViewModel
    @State private var loggingBook: SavedBook?
    private let api: BookAPI
    
    private let library: LibraryRepository
    
    init(api: BookAPI, library: LibraryRepository) {
        self.api = api
        self.library = library
        _viewModel = State(initialValue: LibraryViewModel(api: api, library: library))
    }
    var body: some View {
        VStack(spacing: 0) {
            Picker("Status", selection: $viewModel.selectedStatus) {
                ForEach(ReadingStatus.allCases, id: \.self) {
                    status in Text(status.title).tag(status)
                }
            }
            .pickerStyle(.segmented)
            .padding()
            
            content
        }
        .navigationTitle("Library")
        .navigationDestination(for: BookSummary.self) {
            book in BookDetailView(book: book, api: api, library: library)
        }
        .task(id: viewModel.selectedStatus) { viewModel.load() }
        .onAppear { viewModel.load() }
        .sheet(item: $loggingBook) { book in
            LogSessionSheet(book: book) { pages in
                viewModel.logSession(for: book, pages: pages)
            }
        }
    }
    
    @ViewBuilder
    private var content: some View {
        if viewModel.books.isEmpty {
            ContentUnavailableView("No books here", systemImage: "books.vertical", description: Text("Books you mark as \(viewModel.selectedStatus.title) appear here."))
        } else {
            List(viewModel.books) {
                book in NavigationLink(value: book.summary) {
                    LibraryRow(book: book)
                }
                .swipeActions {
                    Button("Delete", role: .destructive) {
                        viewModel.delete(book)
                    }
                }
                .swipeActions(edge: .leading) {
                    if book.status != .finished {
                        Button("Log pages") {
                            loggingBook = book
                        }
                        .tint(.blue)
                    }
                }
            }
        }
    }
}

#Preview {
    let container = try! AppDatabase.makeContainer(inMemory: true)
    NavigationStack {
        LibraryView(api: OpenLibraryAPI(client: HTTPClient()), library: LibraryRepository(context: container.mainContext))
    }
    .modelContainer(container)
}
