import Foundation

struct AppConfiguration: Sendable {
    let apiBaseURL: URL

    static func live(bundle: Bundle = .main) -> AppConfiguration {
        let configuredValue = bundle.object(forInfoDictionaryKey: "API_BASE_URL") as? String
        let fallbackValue = "https://api.tvmaze.com"
        let value = configuredValue.flatMap { $0.isEmpty ? nil : $0 } ?? fallbackValue

        guard let url = URL(string: value) else {
            preconditionFailure("API_BASE_URL is not a valid URL: \(value)")
        }

        return AppConfiguration(apiBaseURL: url)
    }
}
