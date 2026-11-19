import Foundation

enum APIError: LocalizedError {
    case invalidURL
    case invalidResponse
    case http(statusCode: Int)
    case decoding(Error)
    case offline
    
    var errorDescription: String? {
        switch self {
        case .offline: "You are offline. Check your internet connection."
        case .http(let code): "Request failed. Error \(code)."
        case .http(let code) where code == 429: "Too many request. Try later."
        case .http(let code) where code >= 500: "Open library is currently broken. Try again later."
        case .decoding: " Decoding has failed."
        case .invalidURL: "URL is invalid."
        case .invalidResponse: "The response is invalid."
        }
    }
}
