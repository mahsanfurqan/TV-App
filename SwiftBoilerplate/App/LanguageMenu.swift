import SwiftUI

@MainActor
struct LanguageMenu: View {
    let controller: LocalizationController

    var body: some View {
        Menu {
            ForEach(AppLanguage.allCases) { language in
                Button {
                    controller.select(language)
                } label: {
                    HStack {
                        Text(LocalizedStringKey(language.localizationKey))
                        if controller.language == language {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
        } label: {
            Image(systemName: "globe")
                .fontWeight(.semibold)
        }
        .accessibilityLabel(Text("language.selector.label"))
        .accessibilityIdentifier("language.menu")
    }
}
