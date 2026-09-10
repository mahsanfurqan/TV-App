import Foundation

struct EndpointQueryItem: Hashable, Sendable {
    let name: String
    let value: String?
}

struct Endpoint: Sendable {
    let path: String
    let method: HTTPMethod
    let queryItems: [EndpointQueryItem]
    let headers: [String: String]
    let body: Data?

    init(
        path: String,
        method: HTTPMethod = .get,
        queryItems: [EndpointQueryItem] = [],
        headers: [String: String] = [:],
        body: Data? = nil
    ) {
        self.path = path
        self.method = method
        self.queryItems = queryItems
        self.headers = headers
        self.body = body
    }
}
