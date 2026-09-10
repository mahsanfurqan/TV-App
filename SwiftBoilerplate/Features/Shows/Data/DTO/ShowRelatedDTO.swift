struct SeasonDTO: Decodable, Sendable {
    let id: Int
    let number: Int
    let premiereDate: String?
    let endDate: String?
    let episodeOrder: Int?
    let image: ImageDTO?
    let summary: String?
}

struct EpisodeDTO: Decodable, Sendable {
    let id: Int
    let name: String
    let season: Int?
    let number: Int?
    let airdate: String?
    let image: ImageDTO?
}

struct CastCreditDTO: Decodable, Sendable {
    let person: PersonDTO
    let character: CharacterDTO
}

struct PersonDTO: Decodable, Sendable {
    let id: Int
    let name: String
    let image: ImageDTO?
}

struct CharacterDTO: Decodable, Sendable {
    let id: Int
    let name: String
    let image: ImageDTO?
}

struct ShowBundleDTO: Sendable {
    let show: ShowDTO
    let seasons: [SeasonDTO]
}
