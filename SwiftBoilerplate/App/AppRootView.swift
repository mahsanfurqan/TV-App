import SwiftUI

@MainActor
struct AppRootView: View {
    @State private var router = AppRouter()
    @State private var showsListModel: ShowsListModel
    private let container: AppContainer

    init(container: AppContainer) {
        self.container = container
        _showsListModel = State(initialValue: container.makeShowsListModel())
    }

    var body: some View {
        @Bindable var router = router

        NavigationStack(path: $router.path) {
            ShowsListView(model: showsListModel, router: router)
                .navigationDestination(for: AppRoute.self) { route in
                    switch route {
                    case .showDetail(let id):
                        ShowDetailView(model: container.makeShowDetailModel(showID: id))
                    }
                }
        }
    }
}
