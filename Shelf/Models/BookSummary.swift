import Foundation

struct SearchResponse: Decodable, Sendable {
    let numFound: Int
    let docs: [BookSummary]
}

struct BookSummary: Decodable, Identifiable, Hashable, Sendable {
    let key: String
    let title: String
    let authorNames: [String]?
    let firstPublishYear: Int?
    let coverID: Int?
    let pageCount: Int?
    
    var id: String{key}
    var workID: String {key.replacingOccurrences(of: "/works/", with: "")}
    var authorText: String {authorNames?.joined(separator: ", ") ?? "Unknown author"}
    
    func coverURL(size: String = "M") -> URL? {
        guard let coverID else {return nil}
        return URL(string: "https://covers.openlibrary.org/b/id/\(coverID)-\(size).jpg")
    
        enum CodingKeys: String, CodingKey {
            case key, title
            case authorNames = "author_name"
            case firstPublishYear = "first_publish_year"
            case coverID = "cover_i"
            case pageCount = "number_of_pages_median"
        }
    }
}


