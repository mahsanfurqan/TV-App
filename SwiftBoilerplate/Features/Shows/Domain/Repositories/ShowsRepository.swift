protocol ShowsRepository: Sendable {
    func fetchShows(page: Int, forceRefresh: Bool) async throws -> ShowsPage
    func fetchShowDetail(id: Int, forceRefresh: Bool) async throws -> TVShowDetail
}
