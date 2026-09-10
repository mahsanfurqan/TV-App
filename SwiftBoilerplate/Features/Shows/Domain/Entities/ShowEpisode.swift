import Foundation

struct ShowEpisode: Identifiable, Hashable, Sendable {
    let id: Int
    let name: String
    let seasonNumber: Int?
    let episodeNumber: Int?
    let airDate: Date?
    let imageURL: URL?

    var code: String {
        let season = seasonNumber.map { String(format: "S%02d", $0) } ?? "S--"
        let episode = episodeNumber.map { String(format: "E%02d", $0) } ?? "E--"
        return season + episode
    }
}
