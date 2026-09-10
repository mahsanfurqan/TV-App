import Foundation
import Testing
@testable import SwiftBoilerplate

struct BuildShowsCatalogTests {
    @Test("Catalog orders ratings, premieres, and genre rails deterministically")
    func buildsCollections() {
        let older = makeCatalogShow(
            id: 1,
            rating: 7,
            genres: ["Drama"],
            premiered: Date(timeIntervalSince1970: 100)
        )
        let newer = makeCatalogShow(
            id: 2,
            rating: 9,
            genres: ["Drama", "Comedy"],
            premiered: Date(timeIntervalSince1970: 200)
        )

        let catalog = BuildShowsCatalog()(shows: [older, newer])

        #expect(catalog.featured?.id == 2)
        #expect(catalog.topRated.map(\.id) == [2, 1])
        #expect(catalog.freshPremieres.map(\.id) == [2, 1])
        #expect(catalog.genreCollections.first?.genre == "Drama")
        #expect(catalog.genreCollections.first?.shows.count == 2)
    }
}

private func makeCatalogShow(
    id: Int,
    rating: Double?,
    genres: [String],
    premiered: Date?
) -> TVShow {
    TVShow(
        id: id,
        name: "Show \(id)",
        rating: rating,
        genres: genres,
        premiered: premiered,
        summaryHTML: nil,
        mediumImageURL: nil,
        originalImageURL: URL(string: "https://example.com/show-\(id).jpg")
    )
}
