struct RefreshShows: Sendable {
    private let repository: any ShowsRepository

    init(repository: any ShowsRepository) {
        self.repository = repository
    }

    func callAsFunction() async throws -> ShowsPage {
        try await repository.fetchShows(page: 0, forceRefresh: true)
    }
}
