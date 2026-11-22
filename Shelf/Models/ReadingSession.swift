import Foundation
import SwiftData

@Model
final class ReadingSession {
    var date: Date
    var pages: Int
    var book: SavedBook?
    
    init(date: Date, pages: Int){
        self.date = date
        self.pages = pages
    }
}
