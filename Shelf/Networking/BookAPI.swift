import Foundation

protocol BookAPI: Sendable {
    func search(_ query: String, page: Int) async throws -> SearchResponse
}

struct OpenLibraryAPI: BookAPI {
    let client: HTTPClient
    
    func search(_ query: String, page: Int) async throws -> SearchResponse {
        try await client.get(.search(query: query, page: page))
    }
}
