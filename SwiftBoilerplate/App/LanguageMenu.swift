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
                        Text(verbatim: language.flag)
                        Text(LocalizedStringKey(language.localizationKey))
                        if controller.language == language {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
        } label: {
            Text(verbatim: controller.language.flag)
                .font(.title3)
                .frame(width: 32, height: 32)
        }
        .accessibilityLabel(Text("language.selector.label"))
        .accessibilityValue(Text(LocalizedStringKey(controller.language.localizationKey)))
        .accessibilityIdentifier("language.menu")
    }
}
