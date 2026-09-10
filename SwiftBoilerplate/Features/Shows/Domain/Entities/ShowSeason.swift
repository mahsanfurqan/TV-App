import Foundation

struct ShowSeason: Identifiable, Hashable, Sendable {
    let id: Int
    let number: Int
    let premiereDate: Date?
    let endDate: Date?
    let episodeOrder: Int?
    let imageURL: URL?
    let summaryHTML: String?
}
