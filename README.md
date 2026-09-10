# TV Shows — SwiftUI Clean Architecture

A native SwiftUI TV show browser backed by the public TVMaze API. The project is also a reusable, feature-first Clean Architecture master slice.

## Requirements

- macOS with Xcode 16 or newer
- iOS 17 or newer
- No third-party runtime dependencies

## Run on a Mac

1. Copy this directory to the Mac.
2. Open `SwiftBoilerplate.xcodeproj`.
3. Select the `SwiftBoilerplate` scheme and an iPhone simulator.
4. Press **Cmd+R**.
5. Press **Cmd+U** to run unit and UI tests.

Signing is not required for the simulator. Select an Apple Developer team in Signing & Capabilities only when running on a physical iPhone.

## Features

- Adaptive poster grid with title and nullable rating handling.
- Pull-to-refresh and optional infinite pagination.
- Detail request by show ID with original poster, premiere date, and rendered HTML summary.
- Bonus season, episode, and cast data.
- Episodes grouped by season.
- Native iOS share sheet containing title, plain-text summary, and TVMaze URL.
- Loading, empty, error, retry, refresh, pagination-error, and offline cache states.
- JSON file cache with one-hour freshness and stale-cache fallback.
- Typed navigation and protocol-based dependency injection.
- Unit tests and a critical-path UI launch test.

## API usage

The app uses:

```text
GET /shows?page={page}
GET /shows/{id}?embed[]=episodes&embed[]=cast
GET /shows/{id}/seasons
```

Page zero is sufficient for the assignment. Loading a later page is included as a bonus and stops when TVMaze returns HTTP 404.

## Architecture

```text
Presentation -> Domain <- Data
                     ^
                     |
               AppContainer
```

- `Domain` contains entities, repository protocols, and use cases.
- `Data` owns TVMaze DTOs, cache records, explicit mapping, data sources, and repository implementations.
- `Presentation` contains screen state, `@Observable` models, and SwiftUI views.
- `Core` contains generic state, errors, networking, formatting, reusable state views, and remote images.
- `App` is the composition root and owns typed navigation.

The complete master feature is under `Features/Shows`. See `ARCHITECTURE.md` before copying it for another feature.

## Configuration

Debug and Release settings are stored in `Config/*.xcconfig`. `API_BASE_URL` can be changed without editing application code.

`project.yml` is the maintainable XcodeGen definition. The committed `.xcodeproj` can be opened directly; regeneration is optional:

```bash
brew install xcodegen
xcodegen generate
```

