import Observation

enum AppRoute: Hashable {
    case showDetail(id: Int)
}

@MainActor
@Observable
final class AppRouter {
    var path: [AppRoute] = []

    func showDetail(id: Int) {
        path.append(.showDetail(id: id))
    }

    func popToRoot() {
        path.removeAll()
    }
}
