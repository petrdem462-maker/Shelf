import SwiftUI

struct LogSessionSheet: View {
    let book: SavedBook
    let onSave: (Int) -> Void
    private var maxPages: Int { book.pagesLeft ?? 2000 }

    @State private var pages = 10
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Pages", value: $pages, format: .number)
                        .keyboardType(.numberPad)
                    Stepper("Adjust", value: $pages, in: 0...maxPages)
                } footer: {
                    if let left = book.pagesLeft {
                        Text("\(left) pages left in \(book.title)")
                    } else {
                        Text("Pages read today in \(book.title)")
                    }
                }
            }
            .navigationTitle("Log reading")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        onSave(pages)
                        dismiss()
                    }
                    .disabled(pages == 0 || pages > maxPages)
                }
            }
        }
        .presentationDetents([.medium])
    }
}
