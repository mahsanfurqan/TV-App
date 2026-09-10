import SwiftUI

struct PosterCardView: View {
    let show: TVShow
    var width: CGFloat? = 132

    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.small) {
            ZStack(alignment: .topTrailing) {
                RemoteImageView(url: show.mediumImageURL)
                    .aspectRatio(2.0 / 3.0, contentMode: .fit)
                    .frame(width: width)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.medium, style: .continuous))

                if let rating = show.rating {
                    Text(rating, format: .number.precision(.fractionLength(1)))
                        .font(.caption2.weight(.black))
                        .foregroundStyle(.black)
                        .padding(.horizontal, 7)
                        .padding(.vertical, 5)
                        .background(AppTheme.Colors.accent, in: Capsule())
                        .padding(7)
                }
            }

            Text(show.name)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.white)
                .lineLimit(2, reservesSpace: true)
                .multilineTextAlignment(.leading)
        }
        .frame(width: width, alignment: .leading)
        .frame(maxWidth: width == nil ? .infinity : nil, alignment: .leading)
        .contentShape(Rectangle())
        .accessibilityElement(children: .combine)
        .accessibilityHint(Text("accessibility.open_details"))
    }
}
