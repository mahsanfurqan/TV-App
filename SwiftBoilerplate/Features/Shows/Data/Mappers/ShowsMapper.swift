import Foundation

enum ShowsMapper {
    static func show(from dto: ShowDTO) -> TVShow {
        TVShow(
            id: dto.id,
            name: dto.name,
            rating: dto.rating?.average,
            mediumImageURL: url(dto.image?.medium)
        )
    }

    static func show(from record: ShowRecord) -> TVShow {
        TVShow(
            id: record.id,
            name: record.name,
            rating: record.rating,
            mediumImageURL: url(record.mediumImageURL)
        )
    }

    static func record(from show: TVShow) -> ShowRecord {
        ShowRecord(
            id: show.id,
            name: show.name,
            rating: show.rating,
            mediumImageURL: show.mediumImageURL?.absoluteString
        )
    }

    static func detail(from bundle: ShowBundleDTO) -> TVShowDetail {
        let dto = bundle.show
        return TVShowDetail(
            id: dto.id,
            name: dto.name,
            rating: dto.rating?.average,
            summaryHTML: dto.summary,
            premiered: date(dto.premiered),
            originalImageURL: url(dto.image?.original),
            officialURL: dto.url ?? "https://api.tvmaze.com/shows/\(dto.id)",
            seasons: bundle.seasons.map(season),
            episodes: (dto.embedded?.episodes ?? []).map(episode),
            cast: (dto.embedded?.cast ?? []).map(castMember)
        )
    }

    static func detail(from record: ShowDetailRecord) -> TVShowDetail {
        TVShowDetail(
            id: record.id,
            name: record.name,
            rating: record.rating,
            summaryHTML: record.summaryHTML,
            premiered: record.premiered,
            originalImageURL: url(record.originalImageURL),
            officialURL: record.officialURL,
            seasons: record.seasons.map {
                ShowSeason(
                    id: $0.id,
                    number: $0.number,
                    premiereDate: $0.premiereDate,
                    endDate: $0.endDate,
                    episodeOrder: $0.episodeOrder,
                    imageURL: url($0.imageURL),
                    summaryHTML: $0.summaryHTML
                )
            },
            episodes: record.episodes.map {
                ShowEpisode(
                    id: $0.id,
                    name: $0.name,
                    seasonNumber: $0.seasonNumber,
                    episodeNumber: $0.episodeNumber,
                    airDate: $0.airDate,
                    imageURL: url($0.imageURL)
                )
            },
            cast: record.cast.map {
                CastMember(
                    personID: $0.personID,
                    characterID: $0.characterID,
                    personName: $0.personName,
                    characterName: $0.characterName,
                    imageURL: url($0.imageURL)
                )
            }
        )
    }

    static func record(from detail: TVShowDetail) -> ShowDetailRecord {
        ShowDetailRecord(
            id: detail.id,
            name: detail.name,
            rating: detail.rating,
            summaryHTML: detail.summaryHTML,
            premiered: detail.premiered,
            originalImageURL: detail.originalImageURL?.absoluteString,
            officialURL: detail.officialURL,
            seasons: detail.seasons.map {
                SeasonRecord(
                    id: $0.id,
                    number: $0.number,
                    premiereDate: $0.premiereDate,
                    endDate: $0.endDate,
                    episodeOrder: $0.episodeOrder,
                    imageURL: $0.imageURL?.absoluteString,
                    summaryHTML: $0.summaryHTML
                )
            },
            episodes: detail.episodes.map {
                EpisodeRecord(
                    id: $0.id,
                    name: $0.name,
                    seasonNumber: $0.seasonNumber,
                    episodeNumber: $0.episodeNumber,
                    airDate: $0.airDate,
                    imageURL: $0.imageURL?.absoluteString
                )
            },
            cast: detail.cast.map {
                CastMemberRecord(
                    personID: $0.personID,
                    characterID: $0.characterID,
                    personName: $0.personName,
                    characterName: $0.characterName,
                    imageURL: $0.imageURL?.absoluteString
                )
            }
        )
    }

    private static func season(_ dto: SeasonDTO) -> ShowSeason {
        ShowSeason(
            id: dto.id,
            number: dto.number,
            premiereDate: date(dto.premiereDate),
            endDate: date(dto.endDate),
            episodeOrder: dto.episodeOrder,
            imageURL: url(dto.image?.medium),
            summaryHTML: dto.summary
        )
    }

    private static func episode(_ dto: EpisodeDTO) -> ShowEpisode {
        ShowEpisode(
            id: dto.id,
            name: dto.name,
            seasonNumber: dto.season,
            episodeNumber: dto.number,
            airDate: date(dto.airdate),
            imageURL: url(dto.image?.medium)
        )
    }

    private static func castMember(_ dto: CastCreditDTO) -> CastMember {
        CastMember(
            personID: dto.person.id,
            characterID: dto.character.id,
            personName: dto.person.name,
            characterName: dto.character.name,
            imageURL: url(dto.person.image?.medium ?? dto.character.image?.medium)
        )
    }

    private static func url(_ value: String?) -> URL? {
        value.flatMap(URL.init(string:))
    }

    private static func date(_ value: String?) -> Date? {
        guard let value else { return nil }
        return try? Date(
            value,
            strategy: Date.ISO8601FormatStyle()
                .year()
                .month()
                .day()
        )
    }
}
