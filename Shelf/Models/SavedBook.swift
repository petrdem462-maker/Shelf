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
