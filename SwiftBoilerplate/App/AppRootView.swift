import SwiftUI

@MainActor
struct AppRootView: View {
    @State private var router = AppRouter()
    @State private var showsDiscoverModel: ShowsDiscoverModel
    @State private var localizationController: LocalizationController
    private let container: AppContainer

    init(container: AppContainer) {
        self.container = container
        _showsDiscoverModel = State(initialValue: container.makeShowsDiscoverModel())
        _localizationController = State(initialValue: container.localizationController)
    }

    var body: some View {
        @Bindable var router = router

        NavigationStack(path: $router.path) {
            ShowsDiscoverView(model: showsDiscoverModel, router: router)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        LanguageMenu(controller: localizationController)
                    }
                }
                .navigationDestination(for: AppRoute.self) { route in
                    switch route {
                    case .showDetail(let id):
                        ShowDetailView(model: container.makeShowDetailModel(showID: id))
                    }
                }
        }
        .tint(AppTheme.Colors.accent)
        .environment(\.locale, localizationController.language.locale)
        .preferredColorScheme(.dark)
    }
}
