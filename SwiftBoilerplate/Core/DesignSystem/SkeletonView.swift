import SwiftUI

struct SkeletonView: View {
    let cornerRadius: CGFloat

    init(cornerRadius: CGFloat = AppTheme.Radius.medium) {
        self.cornerRadius = cornerRadius
    }

    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .fill(AppTheme.Colors.elevated)
            .shimmering()
            .accessibilityHidden(true)
    }
}
