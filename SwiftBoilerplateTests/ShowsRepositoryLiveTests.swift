import Foundation
import Testing
@testable import SwiftBoilerplate

struct ShowsRepositoryLiveTests {
    @Test("Remote shows are mapped and cached")
    func mapsAndCachesRemoteShows() async throws {
        let remote = RepositoryRemoteStub(
            showsResult: .success([
                ShowDTO(
                    id: 42,
                    name: "Mapped",
                    rating: RatingDTO(average: nil),
                    image: nil,
                    summary: nil,
                    premiered: nil,
                    url: nil,
                    embedded: nil
                )
            ])
        )
        let local = InMemoryShowsLocalDataSource()
        let repository = ShowsRepositoryLive(
            remoteDataSource: remote,
            localDataSource: local
        )

        let page = try await repository.fetchShows(page: 0, forceRefresh: true)

        #expect(page.shows == [TVShow(id: 42, name: "Mapped", rating: nil, mediumImageURL: nil)])
        #expect(page.origin == .network)
        #expect(await local.savedPage(0)?.shows.count == 1)
    }

    @Test("Stale cache is used when the network fails")
    func fallsBackToCache() async throws {
        let local = InMemoryShowsLocalDataSource()
        let oldDate = Date(timeIntervalSince1970: 100)
        await local.seed(
            ShowsPageCacheRecord(
                savedAt: oldDate,
                shows: [ShowRecord(id: 1, name: "Cached", rating: 5, mediumImageURL: nil)]
            ),
            page: 0
        )
        let remote = RepositoryRemoteStub(
            showsResult: .failure(.transport("Offline"))
        )
        let repository = ShowsRepositoryLive(
            remoteDataSource: remote,
            localDataSource: local,
            cacheLifetime: 1,
            now: { Date(timeIntervalSince1970: 1_000) }
        )

        let page = try await repository.fetchShows(page: 0, forceRefresh: false)

        #expect(page.shows.first?.name == "Cached")
        #expect(page.origin == .cache)
    }

    @Test("A 404 after the first page ends pagination")
    func handlesLastPage() async throws {
        let remote = RepositoryRemoteStub(
            showsResult: .failure(.httpStatus(code: 404, retryAfterSeconds: nil))
        )
        let repository = ShowsRepositoryLive(
            remoteDataSource: remote,
            localDataSource: InMemoryShowsLocalDataSource()
        )

        let page = try await repository.fetchShows(page: 3, forceRefresh: true)

        #expect(page.shows.isEmpty)
        #expect(page.nextPage == nil)
    }
}

private struct RepositoryRemoteStub: ShowsRemoteDataSource {
    let showsResult: Result<[ShowDTO], APIError>

    func fetchShows(page: Int) async throws -> [ShowDTO] {
        try showsResult.get()
    }

    func fetchShowBundle(id: Int) async throws -> ShowBundleDTO {
        throw APIError.httpStatus(code: 404, retryAfterSeconds: nil)
    }
}

private actor InMemoryShowsLocalDataSource: ShowsLocalDataSource {
    private var pages: [Int: ShowsPageCacheRecord] = [:]
    private var details: [Int: ShowDetailCacheRecord] = [:]

    func loadPage(_ page: Int) async throws -> ShowsPageCacheRecord? {
        pages[page]
    }

    func savePage(_ record: ShowsPageCacheRecord, page: Int) async throws {
        pages[page] = record
    }

    func loadDetail(id: Int) async throws -> ShowDetailCacheRecord? {
        details[id]
    }

    func saveDetail(_ record: ShowDetailCacheRecord, id: Int) async throws {
        details[id] = record
    }

    func seed(_ record: ShowsPageCacheRecord, page: Int) {
        pages[page] = record
    }

    func savedPage(_ page: Int) -> ShowsPageCacheRecord? {
        pages[page]
    }
}
