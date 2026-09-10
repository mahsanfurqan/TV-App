import Foundation

struct BuildShowsCatalog: Sendable {
    private let collectionLimit: Int
    private let genreLimit: Int

    init(collectionLimit: Int = 20, genreLimit: Int = 4) {
        self.collectionLimit = collectionLimit
        self.genreLimit = genreLimit
    }

    func callAsFunction(shows: [TVShow]) -> ShowsCatalog {
        let topRated = shows
            .filter { $0.rating != nil }
            .sorted {
                if $0.rating == $1.rating { return $0.id < $1.id }
                return ($0.rating ?? 0) > ($1.rating ?? 0)
            }

        let freshPremieres = shows
            .filter { $0.premiered != nil }
            .sorted {
                if $0.premiered == $1.premiered { return $0.id > $1.id }
                return ($0.premiered ?? .distantPast) > ($1.premiered ?? .distantPast)
            }

        let featured = topRated.first(where: { $0.originalImageURL != nil })
            ?? shows.first(where: { $0.originalImageURL != nil })
            ?? shows.first

        let genreCounts = shows
            .flatMap(\.genres)
            .reduce(into: [String: Int]()) { counts, genre in
                counts[genre, default: 0] += 1
            }

        let genres = genreCounts
            .sorted {
                if $0.value == $1.value { return $0.key < $1.key }
                return $0.value > $1.value
            }
            .prefix(genreLimit)
            .map(\.key)

        let genreCollections = genres.map { genre in
            ShowCollection(
                genre: genre,
                shows: Array(shows.filter { $0.genres.contains(genre) }.prefix(collectionLimit))
            )
        }

        return ShowsCatalog(
            featured: featured,
            topRated: Array(topRated.prefix(collectionLimit)),
            freshPremieres: Array(freshPremieres.prefix(collectionLimit)),
            genreCollections: genreCollections,
            allShows: shows
        )
    }
}
