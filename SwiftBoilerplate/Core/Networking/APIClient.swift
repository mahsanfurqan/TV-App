protocol APIClient: Sendable {
    func send<Response: Decodable & Sendable>(
        _ endpoint: Endpoint,
        as responseType: Response.Type
    ) async throws -> Response
}

