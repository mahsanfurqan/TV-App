import Foundation

@MainActor
struct AppContainer {
    private let showsRepository: any ShowsRepository

    init(showsRepository: any ShowsRepository) {
        self.showsRepository = showsRepository
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

    func makeShowsListModel() -> ShowsListModel {
        ShowsListModel(
            fetchShows: FetchShows(repository: showsRepository),
            refreshShows: RefreshShows(repository: showsRepository)
        )
    }

    func makeShowDetailModel(showID: Int) -> ShowDetailModel {
        ShowDetailModel(
            showID: showID,
            fetchShowDetail: FetchShowDetail(repository: showsRepository)
        )
    }
}
