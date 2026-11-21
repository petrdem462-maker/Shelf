import Foundation
import SwiftData

@MainActor
final class AppDependencies {
    let api: BookAPI = OpenLibraryAPI(client: HTTPClient())
    let container: ModelContainer
    
    init() {
        do{
            container = try AppDatabase.makeContainer()
        } catch {
            fatalError("Could not create database: \(error)")
        }
    }
}
