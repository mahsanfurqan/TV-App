struct FetchShowDetail: Sendable {
    private let repository: any ShowsRepository

    init(repository: any ShowsRepository) {
        self.repository = repository
    }

    func callAsFunction(id: Int, forceRefresh: Bool = false) async throws -> TVShowDetail {
        try await repository.fetchShowDetail(id: id, forceRefresh: forceRefresh)
    }
}
