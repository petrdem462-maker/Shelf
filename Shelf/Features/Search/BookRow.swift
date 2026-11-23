import SwiftUI

struct BookRow: View {
    let book: BookSummary
    
    var body: some View {
        HStack(spacing: 12) {
            CoverImageView(url: book.coverURL(size: "S"))
                            .frame(width: 44, height: 66)
                            .clipShape(RoundedRectangle(cornerRadius: 4))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(book.title)
                    .font(.headline)
                    .lineLimit(2)
                Text(book.authorText)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                if let year = book.firstPublishYear {
                    Text(String(year))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}

#Preview {
    BookRow(book: BookSummary(key: "/works/OL27482W", title: "The Hobbit",
                              authorNames: ["J.R.R. Tolkien"], firstPublishYear: 1937,
                              coverID: 14627509, pageCount: 310))
    .padding()
}
