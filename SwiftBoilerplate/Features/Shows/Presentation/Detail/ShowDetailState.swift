struct ShowDetailState: Equatable, Sendable {
    var phase: LoadState<TVShowDetail> = .idle
    var isRefreshing = false
    var refreshError: AppError?
}
