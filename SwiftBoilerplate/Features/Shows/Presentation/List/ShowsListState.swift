struct ShowsListState: Equatable, Sendable {
    var phase: LoadState<[TVShow]> = .idle
    var isRefreshing = false
    var isLoadingMore = false
    var dataOrigin: ShowsDataOrigin?
    var refreshError: AppError?
    var paginationError: AppError?
}
