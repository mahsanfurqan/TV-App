import Foundation

actor ShowsRepositoryLive: ShowsRepository {
    private let remoteDataSource: any ShowsRemoteDataSource
    private let localDataSource: any ShowsLocalDataSource
    private let cacheLifetime: TimeInterval
    private let now: @Sendable () -> Date

    init(
        remoteDataSource: any ShowsRemoteDataSource,
        localDataSource: any ShowsLocalDataSource,
        cacheLifetime: TimeInterval = 60 * 60,
        now: @escaping @Sendable () -> Date = Date.init
    ) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
        self.cacheLifetime = cacheLifetime
        self.now = now
    }

    func fetchShows(page: Int, forceRefresh: Bool) async throws -> ShowsPage {
        let cached = try? await localDataSource.loadPage(page)

        if !forceRefresh, let cached, isFresh(cached.savedAt) {
            return makePage(from: cached, number: page)
        }

        do {
            let dtos = try await remoteDataSource.fetchShows(page: page)
            let shows = dtos.map(ShowsMapper.show)
            let cache = ShowsPageCacheRecord(
                savedAt: now(),
                shows: shows.map(ShowsMapper.record)
            )
            try? await localDataSource.savePage(cache, page: page)

            return ShowsPage(
                shows: shows,
                nextPage: shows.isEmpty ? nil : page + 1,
                origin: .network
            )
        } catch APIError.httpStatus(code: 404, retryAfterSeconds: _) where page > 0 {
            return ShowsPage(shows: [], nextPage: nil, origin: .network)
        } catch {
            if let cached {
                return makePage(from: cached, number: page)
            }
            throw error
        }
    }

    func fetchShowDetail(id: Int, forceRefresh: Bool) async throws -> TVShowDetail {
        let cached = try? await localDataSource.loadDetail(id: id)

        if !forceRefresh, let cached, isFresh(cached.savedAt) {
            return ShowsMapper.detail(from: cached.detail)
        }

        do {
            let bundle = try await remoteDataSource.fetchShowBundle(id: id)
            let detail = ShowsMapper.detail(from: bundle)
            let cache = ShowDetailCacheRecord(
                savedAt: now(),
                detail: ShowsMapper.record(from: detail)
            )
            try? await localDataSource.saveDetail(cache, id: id)
            return detail
        } catch {
            if let cached {
                return ShowsMapper.detail(from: cached.detail)
            }
            throw error
        }
    }

    private func makePage(from cache: ShowsPageCacheRecord, number: Int) -> ShowsPage {
        let shows = cache.shows.map(ShowsMapper.show)
        return ShowsPage(
            shows: shows,
            nextPage: shows.isEmpty ? nil : number + 1,
            origin: .cache
        )
    }

    private func isFresh(_ savedAt: Date) -> Bool {
        now().timeIntervalSince(savedAt) < cacheLifetime
    }
}
