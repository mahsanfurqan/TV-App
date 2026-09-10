import Foundation

struct AppError: Error, Equatable, Sendable {
    let message: String

    init(message: String) {
        self.message = message
    }

    init(error: Error) {
        message = (error as? LocalizedError)?.errorDescription
            ?? "Something went wrong. Please try again."
    }
}
