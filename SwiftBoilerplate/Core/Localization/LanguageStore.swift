import Foundation

@MainActor
protocol LanguageStoring: AnyObject {
    func load() -> AppLanguage
    func save(_ language: AppLanguage)
}

@MainActor
final class UserDefaultsLanguageStore: LanguageStoring {
    private let userDefaults: UserDefaults
    private let key: String

    init(
        userDefaults: UserDefaults = .standard,
        key: String = "app.selectedLanguage"
    ) {
        self.userDefaults = userDefaults
        self.key = key
    }

    func load() -> AppLanguage {
        guard let value = userDefaults.string(forKey: key) else {
            return .english
        }
        return AppLanguage(rawValue: value) ?? .english
    }

    func save(_ language: AppLanguage) {
        userDefaults.set(language.rawValue, forKey: key)
    }
}
