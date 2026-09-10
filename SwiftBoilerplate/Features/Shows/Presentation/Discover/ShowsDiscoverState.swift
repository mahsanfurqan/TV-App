struct ShowsDiscoverState: Equatable, Sendable {
    var phase: LoadState<ShowsCatalog> = .idle
    var isRefreshing = false
    var isLoadingMore = false
    var dataOrigin: ShowsDataOrigin?
    var refreshError: AppError?
    var paginationError: AppError?
}
