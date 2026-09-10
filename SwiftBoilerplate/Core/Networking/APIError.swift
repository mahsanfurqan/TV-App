import Foundation

enum APIError: LocalizedError, Equatable, Sendable {
    case invalidURL
    case invalidResponse
    case httpStatus(code: Int, retryAfterSeconds: Int?)
    case decoding(String)
    case transport(String)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            "The request URL is invalid."
        case .invalidResponse:
            "The server returned an invalid response."
        case .httpStatus(let statusCode, let retryAfterSeconds):
            switch statusCode {
            case 404:
                "The requested content could not be found."
            case 429:
                if let retryAfterSeconds {
                    "Too many requests. Try again in \(retryAfterSeconds) seconds."
                } else {
                    "Too many requests. Please wait a moment and try again."
                }
            case 500...599:
                "TVMaze is temporarily unavailable. Please try again later."
            default:
                "The server returned status code \(statusCode)."
            }
        case .decoding:
            "The response could not be read."
        case .transport:
            "The server could not be reached. Check your connection and try again."
        }
    }
}
