import SwiftUI

struct ErrorStateView: View {
    @Environment(\.locale) private var locale
    let error: AppError
    let retry: () -> Void

    init(error: AppError, retry: @escaping () -> Void) {
        self.error = error
        self.retry = retry
    }

    var body: some View {
        ContentUnavailableView {
            Label(
                AppErrorLocalizer.title(for: error, locale: locale),
                systemImage: "wifi.exclamationmark"
            )
        } description: {
            Text(AppErrorLocalizer.message(for: error, locale: locale))
        } actions: {
            Button("action.retry", action: retry)
                .buttonStyle(.borderedProminent)
                .tint(AppTheme.Colors.accent)
                .accessibilityIdentifier("state.retry")
        }
        .foregroundStyle(.white)
        .background(AppTheme.Colors.canvas)
        .accessibilityIdentifier("state.error")
    }
}
