import SwiftUI

struct ShowDetailContentView: View {
    @Environment(\.locale) private var locale
    @State private var selectedSeasonNumber: Int?

    let detail: TVShowDetail
    let isRefreshing: Bool
    let refreshError: AppError?
    let shareContent: String
    let refresh: () async -> Void

    init(
        detail: TVShowDetail,
        isRefreshing: Bool,
        refreshError: AppError?,
        shareContent: String,
        refresh: @escaping () async -> Void
    ) {
        self.detail = detail
        self.isRefreshing = isRefreshing
        self.refreshError = refreshError
        self.shareContent = shareContent
        self.refresh = refresh
        _selectedSeasonNumber = State(
            initialValue: detail.seasons.first?.number ?? detail.episodes.first?.seasonNumber
        )
    }

    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(alignment: .leading, spacing: AppTheme.Spacing.section) {
                if let refreshError {
                    Label(
                        AppErrorLocalizer.message(for: refreshError, locale: locale),
                        systemImage: "exclamationmark.triangle"
                    )
                        .font(.footnote)
                        .foregroundStyle(.white)
                        .padding(12)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(AppTheme.Colors.elevated, in: RoundedRectangle(cornerRadius: AppTheme.Radius.medium))
                        .padding(.horizontal)
                }

                ShowDetailHeroView(detail: detail)

                VStack(alignment: .leading, spacing: AppTheme.Spacing.large) {
                    Text(detail.name)
                        .font(.system(size: 34, weight: .black, design: .rounded))
                        .foregroundStyle(.white)
                        .accessibilityIdentifier("showDetail.title")

                    ScrollView(.horizontal) {
                        HStack(spacing: AppTheme.Spacing.small) {
                            RatingView(rating: detail.rating)

                            MetadataPill {
                                HStack(spacing: 5) {
                                    Image(systemName: "calendar")
                                    if let premiered = detail.premiered {
                                        Text(premiered, format: .dateTime.day().month(.abbreviated).year())
                                    } else {
                                        Text("premiere.unknown")
                                    }
                                }
                            }

                            ForEach(detail.genres.prefix(3), id: \.self) { genre in
                                MetadataPill {
                                    Text(verbatim: GenreLocalizer.name(for: genre, locale: locale))
                                }
                            }
                        }
                    }
                    .scrollIndicators(.hidden)

                    HStack(spacing: AppTheme.Spacing.medium) {
                        ShareLink(item: shareContent) {
                            Label("action.share_show", systemImage: "square.and.arrow.up")
                                .font(.subheadline.weight(.bold))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 13)
                        }
                        .buttonStyle(.plain)
                        .foregroundStyle(.black)
                        .background(AppTheme.Colors.accent, in: RoundedRectangle(cornerRadius: AppTheme.Radius.small))

                        if let url = URL(string: detail.officialURL) {
                            Link(destination: url) {
                                Image(systemName: "safari")
                                    .font(.headline)
                                    .frame(width: 48, height: 44)
                            }
                            .foregroundStyle(.white)
                            .background(AppTheme.Colors.elevated, in: RoundedRectangle(cornerRadius: AppTheme.Radius.small))
                            .accessibilityLabel(Text("action.open_tvmaze"))
                        }
                    }
                }
                .padding(.horizontal)

                DetailSection(title: "section.summary") {
                    HTMLSummaryView(html: detail.summaryHTML)
                }
                .padding(.horizontal)

                if !detail.cast.isEmpty {
                    DetailSection(title: "section.cast") {
                        CastCarousel(cast: detail.cast)
                    }
                    .padding(.horizontal)
                }

                if !detail.seasons.isEmpty {
                    DetailSection(title: "section.seasons") {
                        SeasonsCarousel(
                            seasons: detail.seasons,
                            selectedSeasonNumber: $selectedSeasonNumber
                        )
                    }
                    .padding(.horizontal)
                }

                if !filteredEpisodes.isEmpty {
                    DetailSection(title: "section.episodes") {
                        EpisodesList(episodes: filteredEpisodes)
                    }
                    .padding(.horizontal)
                }
            }
            .containerRelativeFrame(.horizontal)
            .padding(.bottom, AppTheme.Spacing.section)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .clipped()
        .refreshable {
            await refresh()
        }
        .overlay(alignment: .top) {
            if isRefreshing {
                ProgressView()
                    .tint(.white)
                    .padding(10)
                    .background(.ultraThinMaterial, in: Capsule())
            }
        }
        .background(AppTheme.Colors.canvas)
    }

    private var filteredEpisodes: [ShowEpisode] {
        guard let selectedSeasonNumber else { return detail.episodes }
        return detail.episodes.filter { $0.seasonNumber == selectedSeasonNumber }
    }
}

private struct DetailSection<Content: View>: View {
    let title: LocalizedStringKey
    private let content: () -> Content

    init(title: LocalizedStringKey, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.content = content
    }

    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.medium) {
            Text(title)
                .font(.title3.bold())
                .foregroundStyle(.white)
                .accessibilityAddTraits(.isHeader)
            content()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
