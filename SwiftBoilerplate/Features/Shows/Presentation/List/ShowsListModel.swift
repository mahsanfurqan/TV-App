import Observation

@MainActor
@Observable
final class ShowsListModel {
    private let fetchShows: FetchShows
    private let refreshShows: RefreshShows

    private(set) var state: ShowsListState
    private var nextPage: Int?

    init(
        fetchShows: FetchShows,
        refreshShows: RefreshShows,
        initialState: ShowsListState = ShowsListState()
    ) {
        self.fetchShows = fetchShows
        self.refreshShows = refreshShows
        self.state = initialState
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
        guard case .loaded(let currentShows) = state.phase,
              currentShow.id == currentShows.last?.id,
              let page = nextPage,
              !state.isLoadingMore else {
            return
        }

        state.isLoadingMore = true
        state.paginationError = nil
        defer { state.isLoadingMore = false }

        do {
            let result = try await fetchShows(page: page)
            let existingIDs = Set(currentShows.map(\.id))
            let newShows = result.shows.filter { !existingIDs.contains($0.id) }
            state.phase = .loaded(currentShows + newShows)
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

            state.phase = result.shows.isEmpty ? .empty : .loaded(result.shows)
            state.dataOrigin = result.origin
            nextPage = result.nextPage
        } catch is CancellationError {
            if !hasContent {
                state.phase = .idle
            }
        } catch {
            if hasContent {
                state.refreshError = AppError(error: error)
            } else {
                state.phase = .failed(AppError(error: error))
            }
        }
    }
}
