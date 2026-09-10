import SwiftUI

#Preview("Discover — English") {
    previewRoot(locale: Locale(identifier: "en"))
}
#Preview("Discover — Indonesia") {
    previewRoot(locale: Locale(identifier: "id"))
}

@MainActor
private func previewRoot(locale: Locale) -> some View {
    let repository = PreviewShowsRepository()
    let catalog = BuildShowsCatalog()(shows: repository.shows)
    let model = ShowsDiscoverModel(
        fetchShows: FetchShows(repository: repository),
        refreshShows: RefreshShows(repository: repository),
        buildCatalog: BuildShowsCatalog(),
        initialState: ShowsDiscoverState(phase: .loaded(catalog))
    )

    return NavigationStack {
        ShowsDiscoverView(model: model, router: AppRouter())
    }
    .environment(\.locale, locale)
    .preferredColorScheme(.dark)
}

private struct PreviewShowsRepository: ShowsRepository {
    let shows = [
        TVShow(
            id: 1,
            name: "Under the Dome",
            rating: 8.7,
            genres: ["Drama", "Science-Fiction"],
            premiered: .now,
            summaryHTML: "<p>A community fights to survive beneath a mysterious dome.</p>",
            mediumImageURL: nil,
            originalImageURL: nil
        ),
        TVShow(
            id: 2,
            name: "Person of Interest",
            rating: 8.9,
            genres: ["Action", "Crime"],
            premiered: .now,
            summaryHTML: "<p>A machine predicts crimes before they happen.</p>",
            mediumImageURL: nil,
            originalImageURL: nil
        )
    ]

    func fetchShows(page: Int, forceRefresh: Bool) async throws -> ShowsPage {
        ShowsPage(shows: shows, nextPage: nil, origin: .network)
    }

    func fetchShowDetail(id: Int, forceRefresh: Bool) async throws -> TVShowDetail {
        TVShowDetail(
            id: id,
            name: shows.first?.name ?? "Show",
            rating: 8.7,
            genres: ["Drama", "Science-Fiction"],
            summaryHTML: "<p>A <b>TVMaze</b> preview.</p>",
            premiered: .now,
            originalImageURL: nil,
            officialURL: "https://www.tvmaze.com",
            seasons: [],
            episodes: [],
            cast: []
        )
    }
}
