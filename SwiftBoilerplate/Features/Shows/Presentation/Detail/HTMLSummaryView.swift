import SwiftUI

struct HTMLSummaryView: View {
    @State private var isExpanded = false
    let html: String?

    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.small) {
            if let attributed = readableSummary,
               !attributed.characters.isEmpty {
                Text(attributed)
                    .font(.body)
                    .foregroundStyle(.white.opacity(0.82))
                    .lineLimit(isExpanded ? nil : 5)
                    .textSelection(.enabled)

                Button(LocalizedStringKey(
                    isExpanded ? "action.show_less" : "action.show_more"
                )) {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isExpanded.toggle()
                    }
                }
                .font(.subheadline.weight(.bold))
                .foregroundStyle(AppTheme.Colors.accentSoft)
            } else {
                Text("summary.unavailable")
                    .font(.body)
                    .foregroundStyle(AppTheme.Colors.secondaryText)
            }
        }
    }

    private var readableSummary: AttributedString? {
        guard var attributed = HTMLTextConverter.attributedString(from: html) else {
            return nil
        }
        attributed.foregroundColor = nil
        return attributed
    }
}
