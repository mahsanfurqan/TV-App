import Foundation
import Testing
@testable import SwiftBoilerplate

struct ShowsMapperTests {
    @Test("Nullable TVMaze fields decode and map safely")
    func mapsNullableFields() throws {
        let data = Data(
            #"{"id":1,"name":"Unrated","rating":{"average":null},"image":null,"summary":null,"premiered":null,"url":"https://www.tvmaze.com/shows/1"}"#.utf8
        )
        let dto = try JSONDecoder().decode(ShowDTO.self, from: data)
        let show = ShowsMapper.show(from: dto)

        #expect(show.id == 1)
        #expect(show.rating == nil)
        #expect(show.genres.isEmpty)
        #expect(show.mediumImageURL == nil)
    }

    @Test("TVMaze dates use year-month-day parsing")
    func parsesPremiereDate() {
        let dto = ShowDTO(
            id: 1,
            name: "Dated",
            rating: RatingDTO(average: 7),
            genres: ["Drama"],
            image: nil,
            summary: nil,
            premiered: "2020-05-21",
            url: nil,
            embedded: nil
        )
        let detail = ShowsMapper.detail(
            from: ShowBundleDTO(show: dto, seasons: [])
        )

        #expect(detail.premiered != nil)
        #expect(detail.genres == ["Drama"])
    }

    @Test("HTML summary produces readable plain text")
    func stripsHTMLForSharing() {
        let text = HTMLTextConverter.plainText(from: "<p>Hello <b>world</b></p>")
        #expect(text == "Hello world")
    }

    @Test("Embedded episodes, cast, and seasons map into detail entities")
    func mapsBonusContent() {
        let episode = EpisodeDTO(
            id: 10,
            name: "Pilot",
            season: 1,
            number: 1,
            airdate: "2020-05-21",
            image: nil
        )
        let cast = CastCreditDTO(
            person: PersonDTO(id: 20, name: "Actor", image: nil),
            character: CharacterDTO(id: 30, name: "Hero", image: nil)
        )
        let show = ShowDTO(
            id: 1,
            name: "Complete",
            rating: RatingDTO(average: 8.4),
            genres: ["Drama"],
            image: nil,
            summary: "<p>Summary</p>",
            premiered: "2020-05-21",
            url: "https://www.tvmaze.com/shows/1/complete",
            embedded: EmbeddedShowDTO(episodes: [episode], cast: [cast])
        )
        let season = SeasonDTO(
            id: 40,
            number: 1,
            premiereDate: "2020-05-21",
            endDate: nil,
            episodeOrder: 10,
            image: nil,
            summary: nil
        )

        let detail = ShowsMapper.detail(
            from: ShowBundleDTO(show: show, seasons: [season])
        )

        #expect(detail.episodes.first?.code == "S01E01")
        #expect(detail.cast.first?.personName == "Actor")
        #expect(detail.cast.first?.characterName == "Hero")
        #expect(detail.seasons.first?.episodeOrder == 10)
    }
}
