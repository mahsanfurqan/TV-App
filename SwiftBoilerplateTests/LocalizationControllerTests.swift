import Foundation
import Testing
@testable import SwiftBoilerplate

@MainActor
struct LocalizationControllerTests {
    @Test("Selected language is persisted and exposed as a locale")
    func selectsLanguage() {
        let store = InMemoryLanguageStore(language: .system)
        let controller = LocalizationController(store: store)

        controller.select(.indonesian)

        #expect(controller.language == .indonesian)
        #expect(controller.language.locale.identifier == "id")
        #expect(store.language == .indonesian)
    }
}

@MainActor
private final class InMemoryLanguageStore: LanguageStoring {
    var language: AppLanguage

    init(language: AppLanguage) {
        self.language = language
    }

    func load() -> AppLanguage {
        language
    }

    func save(_ language: AppLanguage) {
        self.language = language
    }
}
