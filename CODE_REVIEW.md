# AI Code Review Exercise - iOS

The supplied code performs synchronous networking and decoding directly inside an observable object:

```swift
class MovieViewModel: ObservableObject {
    var movies: [Movie] = []

    func loadMovies() {
        let data = try! Data(contentsOf: URL(string: "https://api.example.com/movies")!)
        movies = try! JSONDecoder().decode([Movie].self, from: data)
    }
}
```

## Review findings

### 1. The view will not reliably observe changes

`movies` is not marked `@Published`, so an `ObservableObject` view may not refresh when the array changes.

**Fix:** Publish a single explicit screen state or mark externally observed properties with `@Published`. Prefer `private(set)` so views cannot mutate state arbitrarily.

### 2. Networking blocks the calling thread

`Data(contentsOf:)` is synchronous. When called from the UI, it can freeze scrolling and rendering until the request completes.

**Fix:** Use the asynchronous `URLSession.data(for:)` API from an `async` function.

### 3. Force unwrap can crash

`URL(string: ...)!` terminates the app if the string is invalid.

**Fix:** Construct and validate the URL in an endpoint type or throw an `invalidURL` error.

### 4. Forced error handling can crash

Both `try!` expressions terminate the process for normal failures such as offline mode, timeout, server errors, or malformed JSON.

**Fix:** Use `do/catch`, map technical errors into a user-facing error state, and provide retry behavior.

### 5. HTTP responses are not validated

`Data(contentsOf:)` does not provide an explicit place to validate an `HTTPURLResponse`, status code, MIME type, or retry metadata. An error body could be passed into the decoder as if it were successful data.

**Fix:** Validate that the response is HTTP and that its status is in `200...299` before decoding.

### 6. Required UI states are missing

The model only exposes an array. It cannot distinguish idle, loading, empty, success, and failure states.

**Fix:** Model the complete screen phase with an enum and render each case explicitly.

### 7. UI isolation is not explicit

Observable UI state should be mutated on the main actor. The original type has no `@MainActor` annotation.

**Fix:** Mark the presentation model `@MainActor`.

### 8. Responsibilities are mixed

The view model owns endpoint construction, transport, decoding, and presentation state. Any API or decoding change forces presentation code to change.

**Fix:** Move transport and decoding behind a repository protocol. Let the view model depend on a domain-facing operation.

### 9. Dependencies cannot be substituted

The hard-coded URL and static APIs make deterministic unit tests difficult and encourage real network calls in tests.

**Fix:** Inject a protocol and use a stub in unit tests.

### 10. Repeated loads and cancellation are unmanaged

Multiple calls can create overlapping work, an older response can overwrite a newer one, and work may continue after the screen disappears.

**Fix:** Own a load task, cancel the previous task when appropriate, and handle `CancellationError` without showing it as a failure.

### 11. The type can be subclassed accidentally

There is no demonstrated need for inheritance.

**Fix:** Mark the view model `final` to communicate intent and allow simpler dispatch.

## Example direction

```swift
import Combine
import Foundation

protocol MovieFetching: Sendable {
    func fetchMovies() async throws -> [Movie]
}

enum MovieLoadState {
    case idle
    case loading
    case loaded([Movie])
    case empty
    case failed(String)
}

@MainActor
final class MovieViewModel: ObservableObject {
    @Published private(set) var state: MovieLoadState = .idle

    private let fetcher: any MovieFetching
    private var loadTask: Task<Void, Never>?

    init(fetcher: any MovieFetching) {
        self.fetcher = fetcher
    }

    func loadMovies() {
        loadTask?.cancel()
        loadTask = Task { [weak self] in
            guard let self else { return }
            state = .loading

            do {
                let movies = try await fetcher.fetchMovies()
                try Task.checkCancellation()
                state = movies.isEmpty ? .empty : .loaded(movies)
            } catch is CancellationError {
                return
            } catch {
                state = .failed("Unable to load movies. Please try again.")
            }
        }
    }

    func retry() {
        loadMovies()
    }

    func cancelLoading() {
        loadTask?.cancel()
    }
}
```

The repository implementation would separately use `URLSession`, validate HTTP responses, decode DTOs, and map them into domain `Movie` values. Unit tests could then inject success, empty, failure, and delayed/cancelled stubs without making network requests.
