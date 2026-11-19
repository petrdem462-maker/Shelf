import Foundation

@MainActor
final class AppDependencies {
    let api: BookAPI = OpenLibraryAPI(client: HTTPClient())
}
