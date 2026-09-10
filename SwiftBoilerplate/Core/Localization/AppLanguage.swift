import Foundation

enum AppLanguage: String, CaseIterable, Identifiable, Sendable {
    case system
    case english = "en"
    case indonesian = "id"

    var id: String { rawValue }

    var locale: Locale {
        switch self {
        case .system:
            .autoupdatingCurrent
        case .english:
            Locale(identifier: "en")
        case .indonesian:
            Locale(identifier: "id")
        }
    }

    var localizationKey: String {
        switch self {
        case .system: "language.system"
        case .english: "language.english"
        case .indonesian: "language.indonesian"
        }
    }
}
