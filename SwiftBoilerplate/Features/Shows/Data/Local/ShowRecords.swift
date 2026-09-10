import Foundation

struct ShowsPageCacheRecord: Codable, Sendable {
    let savedAt: Date
    let shows: [ShowRecord]
}

struct ShowRecord: Codable, Sendable {
    let id: Int
    let name: String
    let rating: Double?
    let mediumImageURL: String?
}

struct ShowDetailCacheRecord: Codable, Sendable {
    let savedAt: Date
    let detail: ShowDetailRecord
}

struct ShowDetailRecord: Codable, Sendable {
    let id: Int
    let name: String
    let rating: Double?
    let summaryHTML: String?
    let premiered: Date?
    let originalImageURL: String?
    let officialURL: String
    let seasons: [SeasonRecord]
    let episodes: [EpisodeRecord]
    let cast: [CastMemberRecord]
}

struct SeasonRecord: Codable, Sendable {
    let id: Int
    let number: Int
    let premiereDate: Date?
    let endDate: Date?
    let episodeOrder: Int?
    let imageURL: String?
    let summaryHTML: String?
}

struct EpisodeRecord: Codable, Sendable {
    let id: Int
    let name: String
    let seasonNumber: Int?
    let episodeNumber: Int?
    let airDate: Date?
    let imageURL: String?
}

struct CastMemberRecord: Codable, Sendable {
    let personID: Int
    let characterID: Int
    let personName: String
    let characterName: String
    let imageURL: String?
}
