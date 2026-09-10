import SwiftUI

struct EmptyStateView: View {
    let title: LocalizedStringKey
    let message: LocalizedStringKey
    let retry: () -> Void

    init(
        title: LocalizedStringKey = "state.empty.title",
        message: LocalizedStringKey = "state.empty.message",
        retry: @escaping () -> Void
    ) {
        self.title = title
        self.message = message
        self.retry = retry
    }

    var body: some View {
        ContentUnavailableView {
            Label(title, systemImage: "sparkles.tv")
        } description: {
            Text(message)
        } actions: {
            Button("action.try_again", action: retry)
                .buttonStyle(.borderedProminent)
                .tint(AppTheme.Colors.accent)
        }
        .foregroundStyle(.white)
        .background(AppTheme.Colors.canvas)
        .accessibilityIdentifier("state.empty")
    }
}
