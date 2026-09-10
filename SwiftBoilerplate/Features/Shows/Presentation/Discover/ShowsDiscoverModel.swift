import Foundation
import Observation

@MainActor
@Observable
final class ShowsDiscoverModel {
    private let fetchShows: FetchShows
    private let refreshShows: RefreshShows
    private let buildCatalog: BuildShowsCatalog

    private(set) var state: ShowsDiscoverState
    var searchText = ""
    private var nextPage: Int?

    init(
        fetchShows: FetchShows,
        refreshShows: RefreshShows,
        buildCatalog: BuildShowsCatalog,
        initialState: ShowsDiscoverState = ShowsDiscoverState()
    ) {
        self.fetchShows = fetchShows
        self.refreshShows = refreshShows
        self.buildCatalog = buildCatalog
        self.state = initialState
    }

    var searchResults: [TVShow] {
        guard case .loaded(let catalog) = state.phase else { return [] }
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return catalog.allShows }
        return catalog.allShows.filter { show in
            show.name.localizedCaseInsensitiveContains(query)
                || show.genres.contains { $0.localizedCaseInsensitiveContains(query) }
        }
    }

    var isSearching: Bool {
        !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    func loadIfNeeded() async {
        guard state.phase == .idle else { return }
        await loadFirstPage(forceRefresh: false)
    }

    func retry() async {
        await loadFirstPage(forceRefresh: false)
    }

    func refresh() async {
        await loadFirstPage(forceRefresh: true)
    }

    func loadMoreIfNeeded(currentShow: TVShow) async {
        guard case .loaded(let catalog) = state.phase,
              currentShow.id == catalog.allShows.last?.id,
              let page = nextPage,
              !state.isLoadingMore else {
            return
        }

        state.isLoadingMore = true
        state.paginationError = nil
        defer { state.isLoadingMore = false }

        do {
            let result = try await fetchShows(page: page)
            let existingIDs = Set(catalog.allShows.map(\.id))
            let newShows = result.shows.filter { !existingIDs.contains($0.id) }
            state.phase = .loaded(buildCatalog(shows: catalog.allShows + newShows))
            state.dataOrigin = result.origin
            nextPage = result.nextPage
        } catch is CancellationError {
            return
        } catch {
            state.paginationError = AppError(error: error)
        }
    }

    private func loadFirstPage(forceRefresh: Bool) async {
        let hasContent: Bool
        if case .loaded = state.phase {
            hasContent = true
        } else {
            hasContent = false
            state.phase = .loading
        }

        state.isRefreshing = hasContent && forceRefresh
        state.refreshError = nil
        state.paginationError = nil
        defer { state.isRefreshing = false }

        do {
            let result = forceRefresh
                ? try await refreshShows()
                : try await fetchShows(page: 0)

            state.phase = result.shows.isEmpty
                ? .empty
                : .loaded(buildCatalog(shows: result.shows))
            state.dataOrigin = result.origin
            nextPage = result.nextPage
        } catch is CancellationError {
            if !hasContent { state.phase = .idle }
        } catch {
            if hasContent {
                state.refreshError = AppError(error: error)
            } else {
                state.phase = .failed(AppError(error: error))
            }
        }
    }
}
