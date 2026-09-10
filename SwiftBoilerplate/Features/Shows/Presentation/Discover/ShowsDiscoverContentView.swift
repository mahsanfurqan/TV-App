import SwiftUI

struct ShowsDiscoverContentView: View {
    @Environment(\.locale) private var locale

    let catalog: ShowsCatalog
    let searchResults: [TVShow]
    let isSearching: Bool
    let state: ShowsDiscoverState
    let select: (TVShow) -> Void
    let loadMore: (TVShow) async -> Void
    let refresh: () async -> Void

    var body: some View {
        ScrollView(.vertical) {
            if isSearching {
                searchContent
            } else {
                discoverContent
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .clipped()
        .refreshable { await refresh() }
        .overlay(alignment: .top) {
            if state.isRefreshing {
                ProgressView()
                    .tint(.white)
                    .padding(10)
                    .background(.ultraThinMaterial, in: Capsule())
                    .padding(.top, 8)
            }
        }
        .background(AppTheme.Colors.canvas)
        .accessibilityIdentifier("shows.list")
    }

    private var discoverContent: some View {
        LazyVStack(alignment: .leading, spacing: AppTheme.Spacing.section) {
            statusMessages

            if let featured = catalog.featured {
                FeaturedShowView(show: featured) { select(featured) }
                    .padding(.horizontal)
            }

            if !catalog.topRated.isEmpty {
                ShowRailView(title: "section.top_rated", shows: catalog.topRated, select: select)
            }

            if !catalog.freshPremieres.isEmpty {
                ShowRailView(title: "section.fresh_premieres", shows: catalog.freshPremieres, select: select)
            }

            ForEach(catalog.genreCollections) { collection in
                ShowRailView(
                    titleText: GenreLocalizer.name(for: collection.genre, locale: locale),
                    shows: collection.shows,
                    select: select
                )
            }

            BrowseAllGrid(
                shows: catalog.allShows,
                isLoadingMore: state.isLoadingMore,
                paginationError: state.paginationError,
                select: select,
                loadMore: loadMore
            )
        }
        .containerRelativeFrame(.horizontal)
        .padding(.vertical, AppTheme.Spacing.large)
    }

    private var searchContent: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.large) {
            SectionHeader(title: "section.search_results")

            if searchResults.isEmpty {
                ContentUnavailableView {
                    Label("state.search_empty.title", systemImage: "magnifyingglass")
                } description: {
                    Text("state.search_empty.message")
                }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 80)
            } else {
                BrowseAllGrid(
                    shows: searchResults,
                    isLoadingMore: false,
                    paginationError: nil,
                    select: select,
                    loadMore: { _ in }
                )
            }
        }
        .padding()
        .containerRelativeFrame(.horizontal)
    }

    @ViewBuilder
    private var statusMessages: some View {
        if state.dataOrigin == .cache {
            StatusBanner(key: "state.cached", systemImage: "internaldrive")
                .padding(.horizontal)
                .accessibilityIdentifier("shows.cacheNotice")
        }

        if let error = state.refreshError {
            StatusBanner(
                text: AppErrorLocalizer.message(for: error, locale: locale),
                systemImage: "exclamationmark.triangle"
            )
            .padding(.horizontal)
        }
    }
}

private struct StatusBanner: View {
    private let key: LocalizedStringKey?
    private let text: String?
    let systemImage: String

    init(key: LocalizedStringKey, systemImage: String) {
        self.key = key
        self.text = nil
        self.systemImage = systemImage
    }

    init(text: String, systemImage: String) {
        self.key = nil
        self.text = text
        self.systemImage = systemImage
    }

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: systemImage)
                .foregroundStyle(AppTheme.Colors.accentSoft)
            if let key { Text(key) }
            if let text { Text(text) }
        }
        .font(.footnote.weight(.medium))
        .foregroundStyle(.white)
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AppTheme.Colors.elevated, in: RoundedRectangle(cornerRadius: AppTheme.Radius.medium))
    }
}
