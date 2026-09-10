import Foundation

@MainActor
struct AppContainer {
    private let showsRepository: any ShowsRepository
    let localizationController: LocalizationController

    init(
        showsRepository: any ShowsRepository,
        localizationController: LocalizationController = LocalizationController()
    ) {
        self.showsRepository = showsRepository
        self.localizationController = localizationController
    }

    static func live(configuration: AppConfiguration = .live()) -> AppContainer {
        let apiClient = URLSessionAPIClient(baseURL: configuration.apiBaseURL)
        let remoteDataSource = LiveShowsRemoteDataSource(apiClient: apiClient)

        let cacheDirectory = FileManager.default.urls(
            for: .cachesDirectory,
            in: .userDomainMask
        ).first ?? FileManager.default.temporaryDirectory

        let localDataSource = FileShowsLocalDataSource(
            directoryURL: cacheDirectory
                .appendingPathComponent("SwiftBoilerplate", isDirectory: true)
                .appendingPathComponent("shows", isDirectory: true)
        )

        let repository = ShowsRepositoryLive(
            remoteDataSource: remoteDataSource,
            localDataSource: localDataSource
        )

        return AppContainer(showsRepository: repository)
    }

    func makeShowsDiscoverModel() -> ShowsDiscoverModel {
        ShowsDiscoverModel(
            fetchShows: FetchShows(repository: showsRepository),
            refreshShows: RefreshShows(repository: showsRepository),
            buildCatalog: BuildShowsCatalog()
        )
    }

    func makeShowDetailModel(showID: Int) -> ShowDetailModel {
        ShowDetailModel(
            showID: showID,
            fetchShowDetail: FetchShowDetail(repository: showsRepository)
        )
    }
}
