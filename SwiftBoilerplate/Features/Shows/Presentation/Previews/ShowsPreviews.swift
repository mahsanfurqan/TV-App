import SwiftUI

#Preview("Shows") {
    let repository = PreviewShowsRepository()
    let model = ShowsListModel(
        fetchShows: FetchShows(repository: repository),
        refreshShows: RefreshShows(repository: repository),
        initialState: ShowsListState(phase: .loaded(repository.shows))
    )

    NavigationStack {
        ShowsListView(model: model, router: AppRouter())
    }
}

private struct PreviewShowsRepository: ShowsRepository {
    let shows = [
        TVShow(id: 1, name: "Under the Dome", rating: 6.5, mediumImageURL: nil),
        TVShow(id: 2, name: "Person of Interest", rating: nil, mediumImageURL: nil)
    ]

    func fetchShows(page: Int, forceRefresh: Bool) async throws -> ShowsPage {
        ShowsPage(shows: shows, nextPage: nil, origin: .network)
    }

    func fetchShowDetail(id: Int, forceRefresh: Bool) async throws -> TVShowDetail {
        TVShowDetail(
            id: id,
            name: shows.first?.name ?? "Show",
            rating: 6.5,
            summaryHTML: "<p>A <b>TVMaze</b> preview.</p>",
            premiered: nil,
            originalImageURL: nil,
            officialURL: "https://www.tvmaze.com",
            seasons: [],
            episodes: [],
            cast: []
        )
    }
}
