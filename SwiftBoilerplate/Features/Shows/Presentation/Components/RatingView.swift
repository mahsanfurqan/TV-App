import SwiftUI

struct RatingView: View {
    let rating: Double?
    var compact = false

    var body: some View {
        Label {
            if let rating {
                Text(rating, format: .number.precision(.fractionLength(1)))
            } else {
                Text("rating.not_rated")
            }
        } icon: {
            Image(systemName: rating == nil ? "star" : "star.fill")
                .foregroundStyle(rating == nil ? AppTheme.Colors.secondaryText : AppTheme.Colors.accentSoft)
        }
        .font(compact ? .caption.weight(.bold) : .subheadline.weight(.semibold))
        .foregroundStyle(compact ? .white : AppTheme.Colors.secondaryText)
        .padding(.horizontal, compact ? 10 : 0)
        .padding(.vertical, compact ? 6 : 0)
        .background(compact ? Color.white.opacity(0.12) : .clear, in: Capsule())
        .accessibilityLabel(accessibilityText)
    }

    private var accessibilityText: Text {
        if let rating {
            Text("rating.label")
                + Text(verbatim: " ")
                + Text(rating, format: .number.precision(.fractionLength(1)))
                + Text(verbatim: " ")
                + Text("rating.out_of_ten")
        } else {
            Text("rating.not_rated")
        }
    }
}
