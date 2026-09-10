import Testing
@testable import SwiftBoilerplate

@MainActor
struct ShowDetailModelTests {
    @Test("Detail is loaded by ID and share content contains clean text and URL")
    func loadsDetailAndBuildsShareContent() async {
        let detail = TVShowDetail(
            id: 7,
            name: "Test Show",
            rating: 8.2,
            summaryHTML: "<p>A <b>great</b> show.</p>",
            premiered: nil,
            originalImageURL: nil,
            officialURL: "https://www.tvmaze.com/shows/7/test-show",
            seasons: [],
            episodes: [],
            cast: []
        )
        let repository = DetailStubRepository(detail: detail)
        let model = ShowDetailModel(
            showID: detail.id,
            fetchShowDetail: FetchShowDetail(repository: repository)
        )

        await model.loadIfNeeded()

        #expect(model.state.phase == .loaded(detail))
        #expect(model.shareContent?.contains("Test Show") == true)
        #expect(model.shareContent?.contains("A great show.") == true)
        #expect(model.shareContent?.contains(detail.officialURL) == true)
        #expect(model.shareContent?.contains("<b>") == false)
    }
}

private struct DetailStubRepository: ShowsRepository {
    let detail: TVShowDetail

    func fetchShows(page: Int, forceRefresh: Bool) async throws -> ShowsPage {
        ShowsPage(shows: [], nextPage: nil, origin: .network)
    }

    func fetchShowDetail(id: Int, forceRefresh: Bool) async throws -> TVShowDetail {
        detail
    }
}
