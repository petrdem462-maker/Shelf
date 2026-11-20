import SwiftUI

struct BookDetailView: View {
    @State private var viewModel: BookDetailViewModel
    
    init(book: BookSummary, api: BookAPI) {
        _viewModel = State(initialValue: BookDetailViewModel(book: book, api: api))
    }
    

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                header
                details
            }
            .padding()
        }
        .navigationTitle(viewModel.book.title)
        .navigationBarTitleDisplayMode(.inline)
        .task { await viewModel.load() }
    }
    
    private var header: some View {
        HStack(alignment: .top, spacing: 16) {
            AsyncImage(url:viewModel.book.coverURL(size: "L")) {
                image in image.resizable().scaledToFill()
            } placeholder: {
                Color.secondary.opacity(0.2)
            }
            .frame(width: 120, height: 180)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            VStack(alignment: .leading, spacing: 6) {
                Text(viewModel.book.title)
                    .font(.title2)
                    .bold()
                Text(viewModel.book.authorText)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                if let year = viewModel.book.firstPublishYear {
                    Text(String(year))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
    @ViewBuilder
    private var details: some View {
        switch viewModel.state {
        case .loading:
            ProgressView()
                .frame(maxWidth: .infinity)
        case .failed(let message):
            Text(message)
                .foregroundStyle(.secondary)
        case .loaded(let work, let rating):
            VStack(alignment: .leading, spacing: 12) {
                if let rating, let average = rating.average {
                    Text("★ \(average, specifier: "%.1f") (\(rating.count) ratings)")
                        .font(.subheadline)
                }
                
                if let description = work.description {
                    Text(description)
                } else {
                    Text("No description available.")
                        .foregroundStyle(.secondary)
                }
                
                if !work.subjects.isEmpty {
                    Text(work.subjects.prefix(5).joined(separator: " · "))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}

#Preview {
    NavigationStack{
        BookDetailView(
            book: BookSummary(key: "/works/OL27482W", title: "The Hobbit", authorNames: ["J. R. R. Tolkien"], firstPublishYear: 1937, coverID: 14627509, pageCount: 310),
            api: OpenLibraryAPI(client: HTTPClient()))
    }
}
