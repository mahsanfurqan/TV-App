struct ShowDTO: Decodable, Sendable {
    let id: Int
    let name: String
    let rating: RatingDTO?
    let genres: [String]?
    let image: ImageDTO?
    let summary: String?
    let premiered: String?
    let url: String?
    let embedded: EmbeddedShowDTO?

    enum CodingKeys: String, CodingKey {
        case id, name, rating, genres, image, summary, premiered, url
        case embedded = "_embedded"
    }
}

struct RatingDTO: Decodable, Sendable {
    let average: Double?
}

struct ImageDTO: Codable, Sendable {
    let medium: String?
    let original: String?
}

struct EmbeddedShowDTO: Decodable, Sendable {
    let episodes: [EpisodeDTO]?
    let cast: [CastCreditDTO]?
}
