# TV Shows — SwiftUI Clean Architecture

A native SwiftUI TV show browser backed by the public TVMaze API. The project is also a reusable, feature-first Clean Architecture master slice.

[![iOS](https://github.com/mahsanfurqan/TV-App/actions/workflows/ios.yml/badge.svg)](https://github.com/mahsanfurqan/TV-App/actions/workflows/ios.yml)

## Walkthrough video

[Watch the five-minute walkthrough](https://drive.google.com/file/d/1vq_EZtYWA_VZrFehgW7NkHrwbpTUXxTC/view?usp=drive_link)

## Requirements

- macOS with Xcode 16 or newer
- iOS 17 or newer
- No third-party runtime dependencies

## Run on a Mac

1. Clone the repository: `git clone https://github.com/mahsanfurqan/TV-App.git`.
2. Enter the project directory and open `SwiftBoilerplate.xcodeproj`.
3. Select the `SwiftBoilerplate` scheme.
4. Select an iPhone simulator, such as iPhone 16.
5. Press **Cmd+R** to build and run.
6. Press **Cmd+U** to run unit and UI tests.

Signing is not required for the simulator. Select an Apple Developer team in Signing & Capabilities only when running on a physical iPhone.

## Features

- Premium, dark-first discovery UI inspired by modern streaming products: featured hero, ranked content rails, genre collections, and an adaptive browse-all grid.
- Fast local search across show names and genres.
- English and Indonesian language modes switchable at runtime, identified by flags, and persisted with `UserDefaults`.
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

### Architecture decisions

- Feature-first organization keeps business changes within one vertical slice.
- Domain repository protocols make presentation models independently testable.
- DTOs and cache records never escape the Data layer; explicit mappers protect the domain from TVMaze schema changes.
- `AppContainer` is the only composition root, avoiding hidden global service lookups.
- Generic loading and error primitives live in Core, while screen-specific state stays beside its screen.
- Native Apple frameworks are preferred to keep setup deterministic for a time-boxed exercise.

## Configuration

Debug and Release settings are stored in `Config/*.xcconfig`. `API_BASE_URL` can be changed without editing application code.

The app intentionally has no package dependency, so a fresh clone can build without resolving third-party libraries. Poster loading uses native `AsyncImage`; the boundary is isolated in `RemoteImageView` if a larger app later needs a dedicated image pipeline.

`project.yml` is the maintainable XcodeGen definition. The committed `.xcodeproj` can be opened directly; regeneration is optional:

```bash
brew install xcodegen
xcodegen generate
```

## Tests

The suite covers nullable API mapping, HTML cleanup, date parsing, catalog ordering, repository caching and offline fallback, pagination completion, localization, discovery states, detail sharing, and the critical launch path.

From Xcode, press **Cmd+U**. From Terminal, an equivalent command is:

```bash
xcodebuild test \
  -project SwiftBoilerplate.xcodeproj \
  -scheme SwiftBoilerplate \
  -destination 'platform=iOS Simulator,name=iPhone 16'
```

GitHub Actions also builds and runs the complete suite on every push to `main` and on pull requests.

## Trade-offs and improvements

Given more time, I would:

- Add screenshot tests for compact and regular width layouts.
- Add an injectable image pipeline with memory and disk caching instead of relying on `AsyncImage`.
- Add UI tests for retry, navigation, language selection, and sharing.
- Split stable architectural boundaries into local Swift packages so dependency rules are compiler-enforced.
- Add accessibility audits, Dynamic Type snapshots, and broader VoiceOver verification.
- Improve observability with privacy-safe networking metrics and structured logging.

## Submission documents

- [`AI_LOG.md`](AI_LOG.md) documents how AI assistance was evaluated and corrected.
- [`CODE_REVIEW.md`](CODE_REVIEW.md) contains the requested review of the provided Swift code.
- [`REFLECTION.md`](REFLECTION.md) contains the short written reflection.
