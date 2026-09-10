import SwiftUI

struct EpisodesList: View {
    let episodes: [ShowEpisode]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ForEach(sections) { section in
                DisclosureGroup(section.title) {
                    LazyVStack(spacing: 0) {
                        ForEach(section.episodes) { episode in
                            EpisodeRow(episode: episode)
                            if episode.id != section.episodes.last?.id {
                                Divider()
                            }
                        }
                    }
                    .padding(.top, 8)
                }
                .font(.headline)
            }
        }
    }

    private var sections: [EpisodeSection] {
        let grouped = Dictionary(grouping: episodes) { $0.seasonNumber }
        return grouped
            .map { season, episodes in
                EpisodeSection(
                    seasonNumber: season,
                    episodes: episodes.sorted {
                        ($0.episodeNumber ?? Int.max) < ($1.episodeNumber ?? Int.max)
                    }
                )
            }
            .sorted { ($0.seasonNumber ?? Int.max) < ($1.seasonNumber ?? Int.max) }
    }
}

private struct EpisodeSection: Identifiable {
    let seasonNumber: Int?
    let episodes: [ShowEpisode]

    var id: Int { seasonNumber ?? -1 }
    var title: String { seasonNumber.map { "Season \($0)" } ?? "Specials" }
}

private struct EpisodeRow: View {
    let episode: ShowEpisode

    var body: some View {
        HStack(spacing: 12) {
            RemoteImageView(url: episode.imageURL)
                .frame(width: 96, height: 56)
                .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))

            VStack(alignment: .leading, spacing: 4) {
                Text(episode.name)
                    .font(.subheadline.weight(.semibold))
                    .lineLimit(2)

                HStack(spacing: 8) {
                    Text(episode.code)
                    if let airDate = episode.airDate {
                        Text(airDate.formatted(date: .abbreviated, time: .omitted))
                    }
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }

            Spacer(minLength: 0)
        }
        .padding(.vertical, 8)
        .accessibilityElement(children: .combine)
    }
}
