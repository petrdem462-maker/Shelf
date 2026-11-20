import Testing
import Foundation
@testable import Shelf

struct DecodingTests {
    @Test func decodesSearchResponse() throws {
        let json = """
            {"numFound": 463, "docs": [{"key": "/works/OL27482W", "title": "The Hobbit",
                      "author_name": ["J.R.R. Tolkien"], "first_publish_year": 1937,
                      "cover_i": 14627509, "number_of_pages_median": 310}]}
            """
        let response = try JSONDecoder().decode(SearchResponse.self, from: Data(json.utf8))
        
        #expect(response.numFound == 463)
        #expect(response.docs.count == 1)
        #expect(response.docs[0].workID == "OL27482W")
        #expect(response.docs[0].authorText == "J.R.R. Tolkien")
    }
    
    @Test func missingOptionalFieldsDoNotBreakDecoding() throws {
        let json = """
            {"numFound": 1, "docs": [{"key": "/works/OL1W", "title": "Unknown Book"}]}
            """
        let response = try
        JSONDecoder().decode(SearchResponse.self, from: Data(json.utf8))
        let book = response.docs[0]
        
        #expect(book.coverURL() == nil)
        #expect(book.pageCount == nil)
        #expect(book.authorText == "Unknown author")
    }
    
    @Test func descriptionAsPlainString() throws {
        let json = """
        {"title": "Dune", "description": "A desert planet."}
        """
        let work = try JSONDecoder().decode(WorkDetail.self, from: Data(json.utf8))
        #expect(work.description == "A desert planet.")
    }

    @Test func descriptionAsObject() throws {
        let json = """
        {"title": "Dune", "description": {"type": "/type/text", "value": "A desert planet."}}
        """
        let work = try JSONDecoder().decode(WorkDetail.self, from: Data(json.utf8))
        #expect(work.description == "A desert planet.")
    }

    @Test func missingDescriptionAndSubjects() throws {
        let json = """
        {"title": "Dune"}
        """
        let work = try JSONDecoder().decode(WorkDetail.self, from: Data(json.utf8))
        #expect(work.description == nil)
        #expect(work.subjects.isEmpty)
    }
}
