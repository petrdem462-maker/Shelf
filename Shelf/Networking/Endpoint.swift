import Foundation

enum Endpoint {
    case search(query: String, page: Int)
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "openlibrary.org"
        switch self {
        case .search(let query, let page):
            components.path = "/search.json"
            components.queryItems = [
                URLQueryItem(name: "q", value: query),
                URLQueryItem(name: "page", value: String(page)),
                URLQueryItem(name: "limit", value: "20"),
                URLQueryItem(name: "fields", value: "key,title,author_name,first_publish_year,cover_i,number_of_pages_median")
            ]
        }
        return components.url
    }
}
