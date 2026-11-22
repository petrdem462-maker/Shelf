import SwiftUI

struct LogSessionSheet: View {
    let book: SavedBook
    let onSave: (Int) -> Void

    @State private var pages = 10
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Pages", value: $pages, format: .number)
                        .keyboardType(.numberPad)
                    Stepper("Adjust", value: $pages, in: 0...2000)
                } footer: {
                    Text("Pages read today in \(book.title)")
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
                    .disabled(pages == 0)
                }
            }
        }
        .presentationDetents([.medium])
    }
}
