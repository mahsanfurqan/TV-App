import SwiftUI

struct LoadingStateView: View {
    let message: LocalizedStringKey

    init(message: LocalizedStringKey = "state.loading") {
        self.message = message
    }

    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.section) {
                SkeletonView(cornerRadius: AppTheme.Radius.large)
                    .frame(height: 390)

                VStack(alignment: .leading, spacing: AppTheme.Spacing.medium) {
                    SkeletonView(cornerRadius: 6)
                        .frame(width: 170, height: 22)

                    HStack(spacing: AppTheme.Spacing.medium) {
                        ForEach(0..<3, id: \.self) { _ in
                            SkeletonView()
                                .aspectRatio(2.0 / 3.0, contentMode: .fit)
                                .frame(maxWidth: .infinity)
                        }
                    }
                }

                Text(message)
                    .font(.footnote)
                    .foregroundStyle(AppTheme.Colors.secondaryText)
            }
            .padding()
            .containerRelativeFrame(.horizontal)
        }
        .background(AppTheme.Colors.canvas)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .clipped()
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("state.loading")
    }
}
