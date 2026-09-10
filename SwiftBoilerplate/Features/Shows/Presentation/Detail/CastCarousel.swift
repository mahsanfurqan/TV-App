import SwiftUI

struct CastCarousel: View {
    let cast: [CastMember]

    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(alignment: .top, spacing: AppTheme.Spacing.medium) {
                ForEach(cast) { member in
                    VStack(alignment: .leading, spacing: 6) {
                        RemoteImageView(url: member.imageURL)
                            .frame(width: 110, height: 150)
                            .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.medium, style: .continuous))

                        Text(member.personName)
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.white)
                            .lineLimit(2)

                        (Text("cast.as") + Text(verbatim: " ") + Text(verbatim: member.characterName))
                            .font(.caption)
                            .foregroundStyle(AppTheme.Colors.secondaryText)
                            .lineLimit(2)
                    }
                    .frame(width: 110, alignment: .leading)
                    .accessibilityElement(children: .combine)
                }
            }
        }
        .scrollIndicators(.hidden)
    }
}
