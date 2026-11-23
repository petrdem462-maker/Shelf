import Foundation
import SwiftData

@MainActor
final class AppDependencies {
    let api: BookAPI = OpenLibraryAPI(client: HTTPClient())
    let container: ModelContainer
    let library: LibraryRepository
    
    init() {
        do{
            container = try AppDatabase.makeContainer()
        } catch {
            fatalError("Could not create database: \(error)")
        }
        library = LibraryRepository(context: container.mainContext)
        print(container.configurations.first?.url.path ?? "no store")
    }
}
