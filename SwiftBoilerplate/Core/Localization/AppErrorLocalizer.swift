import Foundation

enum AppErrorLocalizer {
    static func title(for error: AppError, locale: Locale) -> String {
        switch error {
        case .notFound:
            String(localized: "error.not_found.title", locale: locale)
        default:
            String(localized: "error.generic.title", locale: locale)
        }
    }

    static func message(for error: AppError, locale: Locale) -> String {
        switch error {
        case .offline:
            String(localized: "error.offline.message", locale: locale)
        case .notFound:
            String(localized: "error.not_found.message", locale: locale)
        case .rateLimited:
            String(localized: "error.rate_limited.message", locale: locale)
        case .server:
            String(localized: "error.server.message", locale: locale)
        case .invalidResponse:
            String(localized: "error.invalid_response.message", locale: locale)
        case .unknown:
            String(localized: "error.unknown.message", locale: locale)
        }
    }
}
