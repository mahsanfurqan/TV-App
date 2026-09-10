struct FetchShows: Sendable {
    private let repository: any ShowsRepository

    init(repository: any ShowsRepository) {
        self.repository = repository
    }

    func callAsFunction(page: Int) async throws -> ShowsPage {
        try await repository.fetchShows(page: page, forceRefresh: false)
    }
}
