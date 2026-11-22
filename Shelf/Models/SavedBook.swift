import Foundation
import SwiftData

@Model
final class SavedBook {
    @Attribute(.unique) var workID: String
    var title: String
    var author: String
    var coverID: Int?
    var pageCount: Int?
    var statusRaw: String
    var addedAt: Date
    var finishedAt: Date?
    
    @Relationship(deleteRule: .cascade, inverse: \ReadingSession.book)
    var sessions: [ReadingSession] = []
    
    init(workID: String, title: String, author: String, coverID: Int?, pageCount: Int?, status: ReadingStatus){
        self.workID = workID
                self.title = title
                self.author = author
                self.coverID = coverID
                self.pageCount = pageCount
                self.statusRaw = status.rawValue
                self.addedAt = .now
    }
    
    var status: ReadingStatus {
        get {
            ReadingStatus(rawValue: statusRaw) ?? .wantToRead
        }
        set { statusRaw = newValue.rawValue }
    }
}

extension SavedBook {
    var pagesRead: Int {
        sessions.reduce(0) { $0 + $1.pages}
    }
    
    var progress: Double? {
        guard let total = pageCount, total > 0 else { return nil }
        return min(Double(pagesRead) / Double(total), 1)
    }
    
    var summary: BookSummary {
        BookSummary(key: "/works/\(workID)", title: title, authorNames: [author], firstPublishYear: nil, coverID: coverID, pageCount: pageCount)
    }
    
    var pagesLeft: Int? {
            guard let total = pageCount else { return nil }
            return max(total - pagesRead, 0)
        }
}

