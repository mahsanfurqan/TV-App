import SwiftUI

struct SeasonsCarousel: View {
    let seasons: [ShowSeason]
    @Binding var selectedSeasonNumber: Int?

    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: AppTheme.Spacing.small) {
                ForEach(seasons) { season in
                    Button {
                        withAnimation(.easeInOut(duration: 0.18)) {
                            selectedSeasonNumber = season.number
                        }
                    } label: {
                        VStack(alignment: .leading, spacing: 3) {
                            Text("season.label") + Text(verbatim: " \(season.number)")

                            if let count = season.episodeOrder {
                                Text(verbatim: "\(count) ")
                                    + Text(LocalizedStringKey(
                                        count == 1 ? "episode.singular" : "episode.plural"
                                    ))
                            } else {
                                Text("episode.count_unknown")
                            }
                        }
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(selectedSeasonNumber == season.number ? .black : .white)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .background(
                            selectedSeasonNumber == season.number
                                ? AppTheme.Colors.accent
                                : AppTheme.Colors.elevated,
                            in: RoundedRectangle(cornerRadius: AppTheme.Radius.small)
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .scrollIndicators(.hidden)
    }
}
