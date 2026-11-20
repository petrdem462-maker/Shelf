import Foundation

protocol BookAPI: Sendable {
    func search(_ query: String, page: Int) async throws -> SearchResponse
    func work(id: String) async throws -> WorkDetail
    func ratings(workID: String) async throws -> RatingsResponse
}

struct OpenLibraryAPI: BookAPI {
    let client: HTTPClient
    
    func search(_ query: String, page: Int) async throws -> SearchResponse {
        try await client.get(.search(query: query, page: page))
    }
    func work(id: String) async throws -> WorkDetail {
        try await client.get(.work(id: id))
    }
    func ratings(workID: String) async throws -> RatingsResponse {
        try await client.get(.ratings(workID: workID))
    }
}
