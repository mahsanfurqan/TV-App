import SwiftUI

@MainActor
struct ShowsListView: View {
    @State private var model: ShowsListModel
    private let router: AppRouter

    init(model: ShowsListModel, router: AppRouter) {
        _model = State(initialValue: model)
        self.router = router
    }

    var body: some View {
        Group {
            switch model.state.phase {
            case .idle, .loading:
                LoadingStateView(message: "Loading TV shows…")
            case .empty:
                EmptyStateView {
                    Task { await model.retry() }
                }
            case .failed(let error):
                ErrorStateView(message: error.message) {
                    Task { await model.retry() }
                }
            case .loaded(let shows):
                ShowsGridView(
                    shows: shows,
                    state: model.state,
                    select: { router.showDetail(id: $0.id) },
                    loadMore: { show in await model.loadMoreIfNeeded(currentShow: show) },
                    refresh: { await model.refresh() }
                )
            }
        }
        .navigationTitle("TV Shows")
        .accessibilityIdentifier("shows.screen")
        .task {
            await model.loadIfNeeded()
        }
    }
}
