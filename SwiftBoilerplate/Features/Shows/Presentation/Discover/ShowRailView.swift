import SwiftUI

struct ShowRailView: View {
    private let localizedTitle: LocalizedStringKey?
    private let titleText: String?
    let shows: [TVShow]
    let select: (TVShow) -> Void

    init(
        title: LocalizedStringKey,
        shows: [TVShow],
        select: @escaping (TVShow) -> Void
    ) {
        localizedTitle = title
        titleText = nil
        self.shows = shows
        self.select = select
    }

    init(
        titleText: String,
        shows: [TVShow],
        select: @escaping (TVShow) -> Void
    ) {
        localizedTitle = nil
        self.titleText = titleText
        self.shows = shows
        self.select = select
    }

    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.medium) {
            Group {
                if let localizedTitle {
                    Text(localizedTitle)
                } else if let titleText {
                    Text(verbatim: titleText)
                }
            }
            .font(.title3.weight(.bold))
            .foregroundStyle(.white)
            .padding(.horizontal)
            .accessibilityAddTraits(.isHeader)

            ScrollView(.horizontal) {
                LazyHStack(alignment: .top, spacing: AppTheme.Spacing.medium) {
                    ForEach(shows) { show in
                        Button { select(show) } label: {
                            PosterCardView(show: show)
                        }
                        .buttonStyle(PosterPressButtonStyle())
                        .accessibilityIdentifier("shows.item.\(show.id)")
                    }
                }
                .padding(.horizontal)
            }
            .scrollIndicators(.hidden)
        }
    }
}

struct PosterPressButtonStyle: ButtonStyle {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed && !reduceMotion ? 0.96 : 1)
            .opacity(configuration.isPressed ? 0.82 : 1)
            .animation(.easeOut(duration: 0.14), value: configuration.isPressed)
    }
}
