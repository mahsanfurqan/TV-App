protocol ShowsRemoteDataSource: Sendable {
    func fetchShows(page: Int) async throws -> [ShowDTO]
    func fetchShowBundle(id: Int) async throws -> ShowBundleDTO
}

struct LiveShowsRemoteDataSource: ShowsRemoteDataSource {
    private let apiClient: any APIClient

    init(apiClient: any APIClient) {
        self.apiClient = apiClient
    }

    func fetchShows(page: Int) async throws -> [ShowDTO] {
        try await apiClient.send(
            Endpoint(
                path: "/shows",
                queryItems: [EndpointQueryItem(name: "page", value: String(page))]
            ),
            as: [ShowDTO].self
        )
    }

    func fetchShowBundle(id: Int) async throws -> ShowBundleDTO {
        async let show = apiClient.send(
            Endpoint(
                path: "/shows/\(id)",
                queryItems: [
                    EndpointQueryItem(name: "embed[]", value: "episodes"),
                    EndpointQueryItem(name: "embed[]", value: "cast")
                ]
            ),
            as: ShowDTO.self
        )

        async let seasons = apiClient.send(
            Endpoint(path: "/shows/\(id)/seasons"),
            as: [SeasonDTO].self
        )

        let resolvedShow = try await show
        let resolvedSeasons = (try? await seasons) ?? []
        return ShowBundleDTO(show: resolvedShow, seasons: resolvedSeasons)
    }
}
