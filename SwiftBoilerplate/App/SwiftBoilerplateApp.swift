import SwiftUI

@main
@MainActor
struct SwiftBoilerplateApp: App {
    private let container = AppContainer.live()

    var body: some Scene {
        WindowGroup {
            AppRootView(container: container)
        }
    }
}
