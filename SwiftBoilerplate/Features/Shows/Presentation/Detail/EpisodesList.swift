import SwiftUI

struct EpisodesList: View {
    let episodes: [ShowEpisode]

    var body: some View {
        LazyVStack(spacing: AppTheme.Spacing.small) {
            ForEach(episodes.sorted(by: episodeOrder)) { episode in
                EpisodeRow(episode: episode)
            }
        }
    }

    private func episodeOrder(_ lhs: ShowEpisode, _ rhs: ShowEpisode) -> Bool {
        let left = (lhs.seasonNumber ?? Int.max, lhs.episodeNumber ?? Int.max)
        let right = (rhs.seasonNumber ?? Int.max, rhs.episodeNumber ?? Int.max)
        return left < right
    }
}
private struct EpisodeRow: View {
    let episode: ShowEpisode

    var body: some View {
        HStack(spacing: AppTheme.Spacing.medium) {
            RemoteImageView(url: episode.imageURL)
                .frame(width: 112, height: 66)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.small, style: .continuous))

            VStack(alignment: .leading, spacing: AppTheme.Spacing.xSmall) {
                Text(episode.name)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.white)
                    .lineLimit(2)

                HStack(spacing: AppTheme.Spacing.small) {
                    Text(verbatim: episode.code)
                    if let airDate = episode.airDate {
                        Text(airDate, format: .dateTime.day().month(.abbreviated).year())
                    }
                }
                .font(.caption)
                .foregroundStyle(AppTheme.Colors.secondaryText)
            }

            Spacer(minLength: 0)
        }
        .padding(AppTheme.Spacing.small)
        .background(AppTheme.Colors.surface, in: RoundedRectangle(cornerRadius: AppTheme.Radius.medium))
        .accessibilityElement(children: .combine)
    }
}
