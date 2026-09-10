import Foundation

struct CastMember: Identifiable, Hashable, Sendable {
    let personID: Int
    let characterID: Int
    let personName: String
    let characterName: String
    let imageURL: URL?

    var id: String {
        "\(personID)-\(characterID)"
    }
}
