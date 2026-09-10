import Foundation
import Testing
@testable import SwiftBoilerplate

@MainActor
struct ShowsDiscoverModelTests {
    @Test("Initial load builds the discover catalog")
    func initialLoad() async {
        let expected = [makeShow(id: 1, name: "Test Show")]
        let repository = DiscoverRepositoryStub(showsResult: .success(expected))
        let model = makeModel(repository: repository)

        await model.loadIfNeeded()

        guard case .loaded(let catalog) = model.state.phase else {
            Issue.record("Expected loaded state")
            return
        }
        #expect(catalog.allShows == expected)
        #expect(catalog.featured == expected.first)
        #expect(model.state.dataOrigin == .network)
    }

    @Test("An empty response exposes the reusable empty state")
    func emptyLoad() async {
        let repository = DiscoverRepositoryStub(showsResult: .success([]))
        let model = makeModel(repository: repository)

        await model.loadIfNeeded()

        #expect(model.state.phase == .empty)
    }

    @Test("Repository errors become semantic presentation errors")
    func failedLoad() async {
        let repository = DiscoverRepositoryStub(
            showsResult: .failure(.transport("Offline"))
        )
        let model = makeModel(repository: repository)

        await model.loadIfNeeded()

        #expect(model.state.phase == .failed(.offline))
    }

    @Test("Search matches show titles and genres")
    func search() async {
        let shows = [
            makeShow(id: 1, name: "Night Watch", genres: ["Drama"]),
            makeShow(id: 2, name: "Sunrise", genres: ["Comedy"])
        ]
        let model = makeModel(
            repository: DiscoverRepositoryStub(showsResult: .success(shows))
        )
        await model.loadIfNeeded()

        model.searchText = "drama"

        #expect(model.searchResults.map(\.id) == [1])
    }

    private func makeModel(repository: any ShowsRepository) -> ShowsDiscoverModel {
        ShowsDiscoverModel(
            fetchShows: FetchShows(repository: repository),
            refreshShows: RefreshShows(repository: repository),
            buildCatalog: BuildShowsCatalog()
        )
    }
}

private struct DiscoverRepositoryStub: ShowsRepository {
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

private func makeShow(
    id: Int,
    name: String,
    rating: Double? = nil,
    genres: [String] = []
) -> TVShow {
    TVShow(
        id: id,
        name: name,
        rating: rating,
        genres: genres,
        premiered: nil,
        summaryHTML: nil,
        mediumImageURL: nil,
        originalImageURL: nil
    )
}
