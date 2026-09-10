import SwiftUI

struct ErrorStateView: View {
    let title: String
    let message: String
    let retry: () -> Void

    init(
        title: String = "Unable to load",
        message: String,
        retry: @escaping () -> Void
    ) {
        self.title = title
        self.message = message
        self.retry = retry
    }

    var body: some View {
        ContentUnavailableView {
            Label(title, systemImage: "wifi.exclamationmark")
        } description: {
            Text(message)
        } actions: {
            Button("Retry", action: retry)
                .buttonStyle(.borderedProminent)
                .accessibilityIdentifier("state.retry")
        }
        .accessibilityIdentifier("state.error")
    }
}
