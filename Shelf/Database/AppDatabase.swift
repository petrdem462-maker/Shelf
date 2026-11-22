import SwiftData

enum AppDatabase {
    static func makeContainer(inMemory: Bool = false) throws -> ModelContainer {
        let schema = Schema([SavedBook.self, ReadingSession.self])
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: inMemory)
        return try ModelContainer(for: schema, configurations: configuration)
    }
}
