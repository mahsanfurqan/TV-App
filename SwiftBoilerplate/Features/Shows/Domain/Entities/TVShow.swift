import Foundation

struct TVShow: Identifiable, Hashable, Sendable {
    let id: Int
    let name: String
    let rating: Double?
    let genres: [String]
    let premiered: Date?
    let summaryHTML: String?
    let mediumImageURL: URL?
    let originalImageURL: URL?
}
