import SwiftUI

@MainActor
struct ShowDetailView: View {
    @State private var model: ShowDetailModel

    init(model: ShowDetailModel) {
        _model = State(initialValue: model)
    }

    var body: some View {
        Group {
            switch model.state.phase {
            case .idle, .loading:
                LoadingStateView(message: "Loading show details…")
            case .empty:
                EmptyStateView(title: "Show unavailable") {
                    Task { await model.retry() }
                }
            case .failed(let error):
                ErrorStateView(message: error.message) {
                    Task { await model.retry() }
                }
            case .loaded(let detail):
                ShowDetailContentView(
                    detail: detail,
                    isRefreshing: model.state.isRefreshing,
                    refreshError: model.state.refreshError,
                    refresh: { await model.refresh() }
                )
            }
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if let shareContent = model.shareContent {
                ToolbarItem(placement: .topBarTrailing) {
                    ShareLink(item: shareContent) {
                        Label("Share", systemImage: "square.and.arrow.up")
                    }
                    .accessibilityIdentifier("showDetail.share")
                }
            }
        }
        .accessibilityIdentifier("showDetail.screen")
        .task {
            await model.loadIfNeeded()
        }
    }
}
