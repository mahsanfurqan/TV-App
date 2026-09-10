import SwiftUI

struct RemoteImageView: View {
    let url: URL?
    let contentMode: ContentMode

    init(url: URL?, contentMode: ContentMode = .fill) {
        self.url = url
        self.contentMode = contentMode
    }

    var body: some View {
        AsyncImage(
            url: url,
            transaction: Transaction(animation: .easeOut(duration: 0.28))
        ) { phase in
            switch phase {
            case .empty:
                SkeletonView(cornerRadius: 0)
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
                    .transition(.opacity.combined(with: .scale(scale: 1.015)))
            case .failure:
                placeholder
            @unknown default:
                placeholder
            }
        }
    }

    private var placeholder: some View {
        Rectangle()
            .fill(AppTheme.Colors.elevated)
            .overlay {
                Image(systemName: "sparkles.tv")
                    .font(.title2)
                    .foregroundStyle(AppTheme.Colors.secondaryText)
                    .accessibilityHidden(true)
            }
    }
}
