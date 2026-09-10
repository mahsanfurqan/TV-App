import SwiftUI

struct CastCarousel: View {
    let cast: [CastMember]

    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(alignment: .top, spacing: 12) {
                ForEach(cast) { member in
                    VStack(alignment: .leading, spacing: 6) {
                        RemoteImageView(url: member.imageURL)
                            .frame(width: 110, height: 150)
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))

                        Text(member.personName)
                            .font(.subheadline.weight(.semibold))
                            .lineLimit(2)

                        Text("as \(member.characterName)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
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
