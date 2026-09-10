import SwiftUI

struct ShowDetailContentView: View {
    let detail: TVShowDetail
    let isRefreshing: Bool
    let refreshError: AppError?
    let refresh: () async -> Void

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 24) {
                if let refreshError {
                    Label(refreshError.message, systemImage: "exclamationmark.triangle")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .padding(10)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 10))
                }

                RemoteImageView(url: detail.originalImageURL, contentMode: .fit)
                    .aspectRatio(2.0 / 3.0, contentMode: .fit)
                    .frame(maxWidth: 360)
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    .shadow(color: .black.opacity(0.18), radius: 12, y: 6)
                    .frame(maxWidth: .infinity)
                    .accessibilityLabel("Poster for \(detail.name)")

                VStack(alignment: .leading, spacing: 12) {
                    Text(detail.name)
                        .font(.largeTitle.bold())
                        .accessibilityIdentifier("showDetail.title")

                    HStack(spacing: 16) {
                        RatingView(rating: detail.rating)

                        Label {
                            Text(detail.premiered?.formatted(date: .abbreviated, time: .omitted) ?? "Unknown premiere")
                        } icon: {
                            Image(systemName: "calendar")
                        }
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    }
                }

                DetailSection(title: "Summary") {
                    HTMLSummaryView(html: detail.summaryHTML)
                }

                if !detail.cast.isEmpty {
                    DetailSection(title: "Cast") {
                        CastCarousel(cast: detail.cast)
                    }
                }

                if !detail.seasons.isEmpty {
                    DetailSection(title: "Seasons") {
                        SeasonsCarousel(seasons: detail.seasons)
                    }
                }

                if !detail.episodes.isEmpty {
                    DetailSection(title: "Episodes") {
                        EpisodesList(episodes: detail.episodes)
                    }
                }
            }
            .padding()
        }
        .refreshable {
            await refresh()
        }
        .overlay(alignment: .top) {
            if isRefreshing {
                ProgressView()
                    .padding(8)
                    .background(.regularMaterial, in: Capsule())
            }
        }
    }
}

private struct DetailSection<Content: View>: View {
    let title: String
    private let content: () -> Content

    init(title: String, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.content = content
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.title2.bold())
            content()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
