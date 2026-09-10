import Foundation

struct TVShowDetail: Identifiable, Hashable, Sendable {
    let id: Int
    let name: String
    let rating: Double?
    let summaryHTML: String?
    let premiered: Date?
    let originalImageURL: URL?
    let officialURL: String
    let seasons: [ShowSeason]
    let episodes: [ShowEpisode]
    let cast: [CastMember]
}
