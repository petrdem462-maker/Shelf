import SwiftUI

struct CoverImageView: View {
    let url: URL?
    @State private var image: UIImage?

    var body: some View {
        ZStack {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                Color.secondary.opacity(0.2)
                Image(systemName: "book.closed")
                    .foregroundStyle(.secondary)
            }
        }
        .task(id: url) {
            image = nil
            guard let url else { return }
            image = try? await ImageCache.shared.image(for: url)
        }
    }
}

#Preview {
    CoverImageView(url: URL(string: "https://covers.openlibrary.org/b/id/14627509-M.jpg"))
        .frame(width: 120, height: 180)
        .clipShape(RoundedRectangle(cornerRadius: 8))
}
