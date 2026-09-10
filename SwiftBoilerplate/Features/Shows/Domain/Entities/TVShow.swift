import Foundation

struct TVShow: Identifiable, Hashable, Sendable {
    let id: Int
    let name: String
    let rating: Double?
    let mediumImageURL: URL?
}
