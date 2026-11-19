import Foundation

enum ReadingStatus: String, CaseIterable, Codable, Sendable {
    case wantToRead = "want"
    case reading
    case finished
    
    var title: String {
        switch self {
        case .wantToRead: return "Want to read"
        case .reading: return "Reading"
        case .finished: return "Finished"
        }
    }
}
