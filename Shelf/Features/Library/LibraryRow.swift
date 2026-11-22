import SwiftUI

struct LibraryRow: View {
    let book: SavedBook
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            BookRow(book: book.summary)
            if let progress = book.progress {
                ProgressView(value: progress)
                Text("\(book.pagesRead) of \(book.pageCount ?? 0) pages")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
