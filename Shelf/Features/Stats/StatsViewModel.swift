import Foundation
import Observation

@MainActor
@Observable
final class StatsViewModel {
    private(set) var stats = Stats()
    private(set) var days: [(day: Date, pages: Int)] = []

    private let library: LibraryRepository

    init(library: LibraryRepository) {
        self.library = library
    }

    func load() {
        stats = (try? library.stats()) ?? Stats()
        days = (try? library.pagesPerDay()) ?? []
    }
}
