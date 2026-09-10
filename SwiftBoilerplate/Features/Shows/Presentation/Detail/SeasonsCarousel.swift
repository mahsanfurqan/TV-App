import SwiftUI

struct SeasonsCarousel: View {
    let seasons: [ShowSeason]

    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(alignment: .top, spacing: 12) {
                ForEach(seasons) { season in
                    VStack(alignment: .leading, spacing: 6) {
                        RemoteImageView(url: season.imageURL)
                            .frame(width: 105, height: 145)
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))

                        Text("Season \(season.number)")
                            .font(.subheadline.weight(.semibold))

                        Text(episodeCount(for: season))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .frame(width: 105, alignment: .leading)
                    .accessibilityElement(children: .combine)
                }
            }
        }
        .scrollIndicators(.hidden)
    }

    private func episodeCount(for season: ShowSeason) -> String {
        season.episodeOrder.map { "\($0) episodes" } ?? "Episode count unknown"
    }
}
