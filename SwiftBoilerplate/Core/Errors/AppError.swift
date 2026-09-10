import Foundation

enum AppError: Error, Equatable, Sendable {
    case offline
    case notFound
    case rateLimited
    case server
    case invalidResponse
    case unknown

    init(error: Error) {
        guard let apiError = error as? APIError else {
            self = .unknown
            return
        }

        switch apiError {
        case .transport:
            self = .offline
        case .httpStatus(let code, _):
            switch code {
            case 404: self = .notFound
            case 429: self = .rateLimited
            case 500...599: self = .server
            default: self = .invalidResponse
            }
        case .invalidURL, .invalidResponse, .decoding:
            self = .invalidResponse
        }
    }
}
