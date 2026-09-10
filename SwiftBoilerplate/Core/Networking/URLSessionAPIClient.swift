import Foundation

actor URLSessionAPIClient: APIClient {
    private let baseURL: URL
    private let session: URLSession
    private let decoder: JSONDecoder

    init(
        baseURL: URL,
        session: URLSession = .shared,
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.baseURL = baseURL
        self.session = session
        self.decoder = decoder
    }

    func send<Response: Decodable & Sendable>(
        _ endpoint: Endpoint,
        as responseType: Response.Type
    ) async throws -> Response {
        let request = try makeRequest(for: endpoint)

        do {
            let (data, response) = try await session.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }

            guard 200..<300 ~= httpResponse.statusCode else {
                let retryAfter = httpResponse
                    .value(forHTTPHeaderField: "Retry-After")
                    .flatMap(Int.init)
                throw APIError.httpStatus(
                    code: httpResponse.statusCode,
                    retryAfterSeconds: retryAfter
                )
            }

            do {
                return try decoder.decode(responseType, from: data)
            } catch {
                throw APIError.decoding(String(describing: error))
            }
        } catch is CancellationError {
            throw CancellationError()
        } catch let error as APIError {
            throw error
        } catch {
            throw APIError.transport(String(describing: error))
        }
    }

    private func makeRequest(for endpoint: Endpoint) throws -> URLRequest {
        let url = baseURL.appendingPathComponent(
            endpoint.path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        )

        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            throw APIError.invalidURL
        }

        if !endpoint.queryItems.isEmpty {
            components.queryItems = endpoint.queryItems.map {
                URLQueryItem(name: $0.name, value: $0.value)
            }
        }

        guard let resolvedURL = components.url else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: resolvedURL)
        request.httpMethod = endpoint.method.rawValue
        request.httpBody = endpoint.body
        request.timeoutInterval = 30
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        endpoint.headers.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }

        return request
    }
}
