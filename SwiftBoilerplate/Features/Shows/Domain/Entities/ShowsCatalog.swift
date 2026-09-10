struct ShowsCatalog: Equatable, Sendable {
    let featured: TVShow?
    let topRated: [TVShow]
    let freshPremieres: [TVShow]
    let genreCollections: [ShowCollection]
    let allShows: [TVShow]
}

struct ShowCollection: Identifiable, Equatable, Sendable {
    let genre: String
    let shows: [TVShow]

    var id: String { genre }
}
