import SwiftUI

struct SkeletonView: View {
    let cornerRadius: CGFloat

    init(cornerRadius: CGFloat = AppTheme.Radius.medium) {
        self.cornerRadius = cornerRadius
    }

    var body: some View {
        let shape = RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)

        shape
            .fill(AppTheme.Colors.elevated)
            .shimmering()
            .clipShape(shape)
            .accessibilityHidden(true)
    }
}
