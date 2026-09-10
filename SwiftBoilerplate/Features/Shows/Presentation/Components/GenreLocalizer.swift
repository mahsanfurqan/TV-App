import Foundation

enum GenreLocalizer {
    static func name(for genre: String, locale: Locale) -> String {
        switch genre.lowercased() {
        case "action": String(localized: "genre.action", locale: locale)
        case "adventure": String(localized: "genre.adventure", locale: locale)
        case "anime": String(localized: "genre.anime", locale: locale)
        case "comedy": String(localized: "genre.comedy", locale: locale)
        case "crime": String(localized: "genre.crime", locale: locale)
        case "drama": String(localized: "genre.drama", locale: locale)
        case "family": String(localized: "genre.family", locale: locale)
        case "fantasy": String(localized: "genre.fantasy", locale: locale)
        case "horror": String(localized: "genre.horror", locale: locale)
        case "mystery": String(localized: "genre.mystery", locale: locale)
        case "romance": String(localized: "genre.romance", locale: locale)
        case "science-fiction": String(localized: "genre.science_fiction", locale: locale)
        case "thriller": String(localized: "genre.thriller", locale: locale)
        default: genre
        }
    }
}
