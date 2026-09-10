import SwiftUI

struct BrowseAllGrid: View {
    @Environment(\.locale) private var locale

    let shows: [TVShow]
    let isLoadingMore: Bool
    let paginationError: AppError?
    let select: (TVShow) -> Void
    let loadMore: (TVShow) async -> Void

    private let columns = [
        GridItem(.adaptive(minimum: 135, maximum: 190), spacing: AppTheme.Spacing.large, alignment: .top)
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.large) {
            SectionHeader(title: "section.browse_all")

            LazyVGrid(columns: columns, spacing: AppTheme.Spacing.xLarge) {
                ForEach(shows) { show in
                    Button { select(show) } label: {
                        PosterCardView(show: show, width: nil)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(PosterPressButtonStyle())
                    .accessibilityIdentifier("shows.grid.item.\(show.id)")
                    .task { await loadMore(show) }
                }
            }

            if isLoadingMore {
                HStack {
                    Spacer()
                    ProgressView("state.loading.more")
                        .tint(.white)
                        .foregroundStyle(AppTheme.Colors.secondaryText)
                    Spacer()
                }
                .padding()
                .accessibilityIdentifier("shows.loadingMore")
            }

            if let paginationError {
                VStack(spacing: AppTheme.Spacing.small) {
                    Text(AppErrorLocalizer.message(for: paginationError, locale: locale))
                        .font(.footnote)
                        .foregroundStyle(AppTheme.Colors.secondaryText)
                        .multilineTextAlignment(.center)

                    Button("action.retry") {
                        guard let lastShow = shows.last else { return }
                        Task { await loadMore(lastShow) }
                    }
                    .buttonStyle(.bordered)
                    .tint(AppTheme.Colors.accent)
                }
                .frame(maxWidth: .infinity)
                .padding()
            }
        }
        .padding(.horizontal)
    }
}
