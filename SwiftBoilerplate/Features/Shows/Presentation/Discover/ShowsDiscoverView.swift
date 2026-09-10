import SwiftUI

@MainActor
struct ShowsDiscoverView: View {
    @State private var model: ShowsDiscoverModel
    private let router: AppRouter

    init(model: ShowsDiscoverModel, router: AppRouter) {
        _model = State(initialValue: model)
        self.router = router
    }

    var body: some View {
        @Bindable var model = model

        Group {
            switch model.state.phase {
            case .idle, .loading:
                LoadingStateView(message: "state.loading.shows")
            case .empty:
                EmptyStateView {
                    Task { await model.retry() }
                }
            case .failed(let error):
                ErrorStateView(error: error) {
                    Task { await model.retry() }
                }
            case .loaded(let catalog):
                ShowsDiscoverContentView(
                    catalog: catalog,
                    searchResults: model.searchResults,
                    isSearching: model.isSearching,
                    state: model.state,
                    select: { router.showDetail(id: $0.id) },
                    loadMore: { await model.loadMoreIfNeeded(currentShow: $0) },
                    refresh: { await model.refresh() }
                )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .clipped()
        .background(AppTheme.Colors.canvas.ignoresSafeArea())
        .navigationTitle("app.title")
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $model.searchText, prompt: Text("search.placeholder"))
        .accessibilityIdentifier("shows.screen")
        .task { await model.loadIfNeeded() }
    }
}
