import Foundation

struct ShowsPageCacheRecord: Codable, Sendable {
    let savedAt: Date
    let shows: [ShowRecord]
}

struct ShowRecord: Codable, Sendable {
    let id: Int
    let name: String
    let rating: Double?
    let genres: [String]
    let premiered: Date?
    let summaryHTML: String?
    let mediumImageURL: String?
    let originalImageURL: String?

    private enum CodingKeys: String, CodingKey {
        case id, name, rating, genres, premiered, summaryHTML
        case mediumImageURL, originalImageURL
    }

    init(
        id: Int,
        name: String,
        rating: Double?,
        genres: [String],
        premiered: Date?,
        summaryHTML: String?,
        mediumImageURL: String?,
        originalImageURL: String?
    ) {
        self.id = id
        self.name = name
        self.rating = rating
        self.genres = genres
        self.premiered = premiered
        self.summaryHTML = summaryHTML
        self.mediumImageURL = mediumImageURL
        self.originalImageURL = originalImageURL
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        rating = try container.decodeIfPresent(Double.self, forKey: .rating)
        genres = try container.decodeIfPresent([String].self, forKey: .genres) ?? []
        premiered = try container.decodeIfPresent(Date.self, forKey: .premiered)
        summaryHTML = try container.decodeIfPresent(String.self, forKey: .summaryHTML)
        mediumImageURL = try container.decodeIfPresent(String.self, forKey: .mediumImageURL)
        originalImageURL = try container.decodeIfPresent(String.self, forKey: .originalImageURL)
    }
}

struct ShowDetailCacheRecord: Codable, Sendable {
    let savedAt: Date
    let detail: ShowDetailRecord
}

struct ShowDetailRecord: Codable, Sendable {
    let id: Int
    let name: String
    let rating: Double?
    let genres: [String]
    let summaryHTML: String?
    let premiered: Date?
    let originalImageURL: String?
    let officialURL: String
    let seasons: [SeasonRecord]
    let episodes: [EpisodeRecord]
    let cast: [CastMemberRecord]

    private enum CodingKeys: String, CodingKey {
        case id, name, rating, genres, summaryHTML, premiered, originalImageURL
        case officialURL, seasons, episodes, cast
    }

    init(
        id: Int,
        name: String,
        rating: Double?,
        genres: [String],
        summaryHTML: String?,
        premiered: Date?,
        originalImageURL: String?,
        officialURL: String,
        seasons: [SeasonRecord],
        episodes: [EpisodeRecord],
        cast: [CastMemberRecord]
    ) {
        self.id = id
        self.name = name
        self.rating = rating
        self.genres = genres
        self.summaryHTML = summaryHTML
        self.premiered = premiered
        self.originalImageURL = originalImageURL
        self.officialURL = officialURL
        self.seasons = seasons
        self.episodes = episodes
        self.cast = cast
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        rating = try container.decodeIfPresent(Double.self, forKey: .rating)
        genres = try container.decodeIfPresent([String].self, forKey: .genres) ?? []
        summaryHTML = try container.decodeIfPresent(String.self, forKey: .summaryHTML)
        premiered = try container.decodeIfPresent(Date.self, forKey: .premiered)
        originalImageURL = try container.decodeIfPresent(String.self, forKey: .originalImageURL)
        officialURL = try container.decode(String.self, forKey: .officialURL)
        seasons = try container.decode([SeasonRecord].self, forKey: .seasons)
        episodes = try container.decode([EpisodeRecord].self, forKey: .episodes)
        cast = try container.decode([CastMemberRecord].self, forKey: .cast)
    }
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
