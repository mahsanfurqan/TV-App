import Foundation

enum AppLanguage: String, CaseIterable, Identifiable, Sendable {
    case english = "en"
    case indonesian = "id"

    var id: String { rawValue }

    var locale: Locale {
        switch self {
        case .english:
            Locale(identifier: "en")
        case .indonesian:
            Locale(identifier: "id")
        }
    }

    var localizationKey: String {
        switch self {
        case .english: "language.english"
        case .indonesian: "language.indonesian"
        }
    }

    var flag: String {
        switch self {
        case .english: "🇬🇧"
        case .indonesian: "🇮🇩"
        }
    }
}
