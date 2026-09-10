import Observation

@MainActor
@Observable
final class ShowDetailModel {
    let showID: Int
    private let fetchShowDetail: FetchShowDetail

    private(set) var state: ShowDetailState

    init(
        showID: Int,
        fetchShowDetail: FetchShowDetail,
        initialState: ShowDetailState = ShowDetailState()
    ) {
        self.showID = showID
        self.fetchShowDetail = fetchShowDetail
        self.state = initialState
    }

    var shareContent: String? {
        guard case .loaded(let detail) = state.phase else { return nil }
        let summary = HTMLTextConverter.plainText(from: detail.summaryHTML)
        return [detail.name, summary, detail.officialURL]
            .filter { !$0.isEmpty }
            .joined(separator: "\n\n")
    }

    func loadIfNeeded() async {
        guard state.phase == .idle else { return }
        await load(forceRefresh: false)
    }

    func retry() async {
        await load(forceRefresh: false)
    }

    func refresh() async {
        await load(forceRefresh: true)
    }

    private func load(forceRefresh: Bool) async {
        let hasContent: Bool
        if case .loaded = state.phase {
            hasContent = true
        } else {
            hasContent = false
            state.phase = .loading
        }

        state.isRefreshing = hasContent && forceRefresh
        state.refreshError = nil
        defer { state.isRefreshing = false }

        do {
            state.phase = .loaded(
                try await fetchShowDetail(id: showID, forceRefresh: forceRefresh)
            )
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
