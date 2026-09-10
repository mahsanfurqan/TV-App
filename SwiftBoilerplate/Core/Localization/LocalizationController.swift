import Observation

@MainActor
@Observable
final class LocalizationController {
    private let store: any LanguageStoring
    private(set) var language: AppLanguage

    init(store: any LanguageStoring = UserDefaultsLanguageStore()) {
        self.store = store
        self.language = store.load()
    }

    func select(_ language: AppLanguage) {
        guard self.language != language else { return }
        self.language = language
        store.save(language)
    }
}
