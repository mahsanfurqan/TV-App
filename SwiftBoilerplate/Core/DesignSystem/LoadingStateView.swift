import SwiftUI

struct LoadingStateView: View {
    let message: String

    init(message: String = "Loading…") {
        self.message = message
    }

    var body: some View {
        VStack(spacing: 12) {
            ProgressView()
            Text(message)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .accessibilityElement(children: .combine)
        .accessibilityIdentifier("state.loading")
    }
}
