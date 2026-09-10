import SwiftUI

struct FeaturedShowView: View {
    @Environment(\.locale) private var locale

    let show: TVShow
    let open: () -> Void

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            RemoteImageView(url: show.originalImageURL ?? show.mediumImageURL)
                .frame(maxWidth: .infinity)
                .frame(height: 440)
                .clipped()
                .overlay {
                    LinearGradient(
                        colors: [.clear, AppTheme.Colors.canvas.opacity(0.25), AppTheme.Colors.canvas],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                }
                .overlay {
                    LinearGradient(
                        colors: [.black.opacity(0.70), .clear],
                        startPoint: .bottomLeading,
                        endPoint: .topTrailing
                    )
                }

            VStack(alignment: .leading, spacing: AppTheme.Spacing.medium) {
                Text("section.featured")
                    .font(.caption.weight(.black))
                    .tracking(1.4)
                    .foregroundStyle(AppTheme.Colors.accentSoft)

                Text(show.name)
                    .font(.system(size: 34, weight: .black, design: .rounded))
                    .foregroundStyle(.white)
                    .lineLimit(2)
                    .minimumScaleFactor(0.78)

                HStack(spacing: AppTheme.Spacing.small) {
                    RatingView(rating: show.rating, compact: true)

                    if let year = show.premiered?.formatted(.dateTime.year()) {
                        MetadataPill { Text(verbatim: year) }
                    }

                    if let genre = show.genres.first {
                        MetadataPill {
                            Text(verbatim: GenreLocalizer.name(for: genre, locale: locale))
                        }
                    }
                }

                let summary = HTMLTextConverter.plainText(from: show.summaryHTML)
                if !summary.isEmpty {
                    Text(verbatim: summary)
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.82))
                        .lineLimit(3)
                }

                Button(action: open) {
                    Label("action.view_details", systemImage: "arrow.right")
                        .font(.subheadline.weight(.bold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 13)
                }
                .buttonStyle(.plain)
                .foregroundStyle(.black)
                .background(AppTheme.Colors.accent, in: RoundedRectangle(cornerRadius: AppTheme.Radius.small))
                .accessibilityIdentifier("shows.featured.open")
            }
            .padding(AppTheme.Spacing.xLarge)
        }
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.large, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: AppTheme.Radius.large, style: .continuous)
                .stroke(.white.opacity(0.08), lineWidth: 1)
        }
        .shadow(color: .black.opacity(0.35), radius: 24, y: 14)
        .accessibilityElement(children: .contain)
    }
}
