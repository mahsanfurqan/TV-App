import Testing
@testable import SwiftBoilerplate

@MainActor
struct ShowsListModelTests {
    @Test("Initial load exposes shows")
    func initialLoad() async {
        let expected = [TVShow(id: 1, name: "Test Show", rating: nil, mediumImageURL: nil)]
        let repository = StubShowsRepository(showsResult: .success(expected))
        let model = makeModel(repository: repository)

        await model.loadIfNeeded()

        #expect(model.state.phase == .loaded(expected))
        #expect(model.state.dataOrigin == .network)
    }

    @Test("An empty response exposes the reusable empty state")
    func emptyLoad() async {
        let repository = StubShowsRepository(showsResult: .success([]))
        let model = makeModel(repository: repository)

        await model.loadIfNeeded()

        #expect(model.state.phase == .empty)
    }

    @Test("Repository errors become presentation errors")
    func failedLoad() async {
        let repository = StubShowsRepository(
            showsResult: .failure(.transport("Offline"))
        )
        let model = makeModel(repository: repository)

        await model.loadIfNeeded()

        guard case .failed(let error) = model.state.phase else {
            Issue.record("Expected failed state")
            return
        }
        #expect(error.message.contains("connection"))
    }

    private func makeModel(repository: any ShowsRepository) -> ShowsListModel {
        ShowsListModel(
            fetchShows: FetchShows(repository: repository),
            refreshShows: RefreshShows(repository: repository)
        )
    }
}

private struct StubShowsRepository: ShowsRepository {
    let showsResult: Result<[TVShow], APIError>

    func fetchShows(page: Int, forceRefresh: Bool) async throws -> ShowsPage {
        ShowsPage(
            shows: try showsResult.get(),
            nextPage: nil,
            origin: .network
        )
    }

    func fetchShowDetail(id: Int, forceRefresh: Bool) async throws -> TVShowDetail {
        throw APIError.httpStatus(code: 404, retryAfterSeconds: nil)
    }
}
