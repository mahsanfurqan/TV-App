import SwiftUI

struct ShowCardView: View {
    let show: TVShow

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            RemoteImageView(url: show.mediumImageURL)
                .aspectRatio(2.0 / 3.0, contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

            Text(show.name)
                .font(.headline)
                .lineLimit(2, reservesSpace: true)
                .multilineTextAlignment(.leading)

            RatingView(rating: show.rating)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(Rectangle())
        .accessibilityElement(children: .combine)
        .accessibilityHint("Opens show details")
    }
}
