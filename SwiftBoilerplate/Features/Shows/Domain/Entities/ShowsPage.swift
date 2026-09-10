enum ShowsDataOrigin: Equatable, Sendable {
    case cache
    case network
}

struct ShowsPage: Equatable, Sendable {
    let shows: [TVShow]
    let nextPage: Int?
    let origin: ShowsDataOrigin
}
