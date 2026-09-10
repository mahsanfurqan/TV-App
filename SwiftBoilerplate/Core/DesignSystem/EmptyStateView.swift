import SwiftUI

struct EmptyStateView: View {
    let title: String
    let message: String
    let retry: () -> Void

    init(
        title: String = "No shows",
        message: String = "There is no content to display yet.",
        retry: @escaping () -> Void
    ) {
        self.title = title
        self.message = message
        self.retry = retry
    }

    var body: some View {
        ContentUnavailableView {
            Label(title, systemImage: "tv")
        } description: {
            Text(message)
        } actions: {
            Button("Try Again", action: retry)
                .buttonStyle(.borderedProminent)
        }
        .accessibilityIdentifier("state.empty")
    }
}
