import SwiftUI

struct ShowsGridView: View {
    let shows: [TVShow]
    let state: ShowsListState
    let select: (TVShow) -> Void
    let loadMore: (TVShow) async -> Void
    let refresh: () async -> Void

    private let columns = [
        GridItem(.adaptive(minimum: 145, maximum: 220), spacing: 16, alignment: .top)
    ]

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                if let error = state.refreshError {
                    Label(error.message, systemImage: "exclamationmark.triangle")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(10)
                        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 10))
                }

                if state.dataOrigin == .cache {
                    Label("Showing cached data", systemImage: "internaldrive")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .accessibilityIdentifier("shows.cacheNotice")
                }

                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(shows) { show in
                        Button {
                            select(show)
                        } label: {
                            ShowCardView(show: show)
                        }
                        .buttonStyle(.plain)
                        .accessibilityIdentifier("shows.item.\(show.id)")
                        .task {
                            await loadMore(show)
                        }
                    }
                }

                if state.isLoadingMore {
                    ProgressView("Loading more shows…")
                        .padding()
                        .accessibilityIdentifier("shows.loadingMore")
                }

                if let error = state.paginationError {
                    VStack(spacing: 8) {
                        Label(error.message, systemImage: "exclamationmark.triangle")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)

                        Button("Retry") {
                            guard let lastShow = shows.last else { return }
                            Task { await loadMore(lastShow) }
                        }
                        .buttonStyle(.bordered)
                    }
                    .padding()
                }
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .refreshable {
            await refresh()
        }
        .overlay(alignment: .top) {
            if state.isRefreshing {
                ProgressView()
                    .padding(8)
                    .background(.regularMaterial, in: Capsule())
            }
        }
        .accessibilityIdentifier("shows.list")
    }
}
