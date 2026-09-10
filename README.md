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

- Premium, dark-first discovery UI inspired by modern streaming products: featured hero, ranked content rails, genre collections, and an adaptive browse-all grid.
- Fast local search across show names and genres.
- English, Indonesian, and system-language modes switchable at runtime and persisted with `UserDefaults`.
- String Catalog localization for UI copy and the app display name.
- Nullable ratings, images, summaries, and premiere dates are handled without unsafe assumptions.
- Pull-to-refresh and optional infinite pagination.
- Immersive detail screen with original artwork, premiere date, expandable rendered HTML summary, and TVMaze link.
- Bonus season selector, filtered episode list, and cast rail.
- Native iOS share sheet containing title, plain-text summary, and TVMaze URL.
- Shimmer loading, empty, semantic error, retry, refresh, pagination-error, and offline cache states.
- JSON file cache with one-hour freshness and stale-cache fallback.
- Typed navigation and protocol-based dependency injection.
- Unit tests for mapping, repositories, catalog construction, localization state, discovery/detail models, plus a critical-path UI launch test.
- GitHub Actions runs the full simulator test suite on every push to `main` and on pull requests.

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
- `Core` contains generic state, semantic errors, networking, formatting, localization, and the reusable design system.
- `App` is the composition root and owns typed navigation plus app-wide language selection.

The complete master feature is under `Features/Shows`. See `ARCHITECTURE.md` before copying it for another feature.

## Configuration

Debug and Release settings are stored in `Config/*.xcconfig`. `API_BASE_URL` can be changed without editing application code.

The app intentionally has no package dependency, so a fresh clone can build without resolving third-party libraries. Poster loading uses native `AsyncImage`; the boundary is isolated in `RemoteImageView` if a larger app later needs a dedicated image pipeline.

`project.yml` is the maintainable XcodeGen definition. The committed `.xcodeproj` can be opened directly; regeneration is optional:

```bash
brew install xcodegen
xcodegen generate
```
