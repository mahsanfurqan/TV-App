import SwiftUI

struct ShowDetailHeroView: View {
    let detail: TVShowDetail

    var body: some View {
        ZStack(alignment: .bottom) {
            RemoteImageView(url: detail.originalImageURL)
                .frame(maxWidth: .infinity)
                .frame(height: 380)
                .clipped()
                .blur(radius: 16)
                .scaleEffect(1.12)
                .opacity(0.52)

            LinearGradient(
                colors: [.black.opacity(0.05), AppTheme.Colors.canvas],
                startPoint: .top,
                endPoint: .bottom
            )

            RemoteImageView(url: detail.originalImageURL, contentMode: .fit)
                .frame(width: 180, height: 270)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.large, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: AppTheme.Radius.large, style: .continuous)
                        .stroke(.white.opacity(0.12), lineWidth: 1)
                }
                .shadow(color: .black.opacity(0.55), radius: 24, y: 14)
                .padding(.bottom, 8)
                .accessibilityLabel(
                    Text("accessibility.poster")
                        + Text(verbatim: " ")
                        + Text(verbatim: detail.name)
                )
        }
        .frame(height: 390)
        .clipped()
    }
}
