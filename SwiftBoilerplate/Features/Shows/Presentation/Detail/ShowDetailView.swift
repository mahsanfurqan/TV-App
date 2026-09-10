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
                LoadingStateView(message: "state.loading.detail")
            case .empty:
                EmptyStateView(title: "state.detail_unavailable.title") {
                    Task { await model.retry() }
                }
            case .failed(let error):
                ErrorStateView(error: error) {
                    Task { await model.retry() }
                }
            case .loaded(let detail):
                ShowDetailContentView(
                    detail: detail,
                    isRefreshing: model.state.isRefreshing,
                    refreshError: model.state.refreshError,
                    shareContent: model.shareContent ?? detail.officialURL,
                    refresh: { await model.refresh() }
                )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .clipped()
        .navigationTitle("navigation.details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if let shareContent = model.shareContent {
                ToolbarItem(placement: .topBarTrailing) {
                    ShareLink(item: shareContent) {
                        Label("action.share", systemImage: "square.and.arrow.up")
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
