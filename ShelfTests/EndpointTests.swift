import Foundation
import Testing
@testable import Shelf

struct EndpointTesting {
    @Test func searchURLContainsAllParameters() throws {
        let url = try #require(Endpoint.search(query: "dune", page: 2).url)
        let text = url.absoluteString
        
        #expect(text.hasPrefix("https://openlibrary.org/search.json?"))
        #expect(text.contains("q=dune"))
        #expect(text.contains("page=2"))
        #expect(text.contains("limit=20"))
    }
    
    @Test func searchQueryIsPercentEncoded() throws {
        let url = try #require(Endpoint.search(query: "harry potter", page: 2).url)
        let text = url.absoluteString
        
        #expect(text.contains("q=harry%20potter"))
    }
}
