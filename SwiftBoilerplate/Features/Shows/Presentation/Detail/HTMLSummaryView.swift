import SwiftUI

struct HTMLSummaryView: View {
    let html: String?

    var body: some View {
        if let attributed = HTMLTextConverter.attributedString(from: html),
           !attributed.characters.isEmpty {
            Text(attributed)
                .font(.body)
                .foregroundStyle(.primary)
                .textSelection(.enabled)
        } else {
            Text("No summary available.")
                .font(.body)
                .foregroundStyle(.secondary)
        }
    }
}
