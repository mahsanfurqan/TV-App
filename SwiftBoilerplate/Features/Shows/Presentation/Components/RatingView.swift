import SwiftUI

struct RatingView: View {
    let rating: Double?

    var body: some View {
        Label {
            Text(rating.map { $0.formatted(.number.precision(.fractionLength(1))) } ?? "Not rated")
        } icon: {
            Image(systemName: rating == nil ? "star" : "star.fill")
                .foregroundStyle(rating == nil ? Color.secondary : Color.yellow)
        }
        .font(.subheadline.weight(.medium))
        .foregroundStyle(.secondary)
        .accessibilityLabel(rating.map { "Rating \($0, format: .number.precision(.fractionLength(1))) out of 10" } ?? "Not rated")
    }
}
