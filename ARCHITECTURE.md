# Architecture Guide

`Features/Shows` is the master vertical slice. It is intentionally complete enough to copy when implementing another business feature.

## Dependency rule

```text
┌────────────────────────────────────────────────────────────┐
│ App                                                        │
│ Composition, configuration, root navigation                │
└───────────────┬──────────────────────────┬─────────────────┘
                │ creates                  │ creates
                ▼                          ▼
┌───────────────────────────┐   ┌────────────────────────────┐
│ Presentation              │   │ Data                       │
│ SwiftUI views             │   │ Repository implementation  │
│ @Observable models        │   │ Remote/local data sources  │
│ Feature-specific state    │   │ DTOs, records, mappers     │
└───────────────┬───────────┘   └──────────────┬─────────────┘
                │ uses                         │ implements
                ▼                              ▼
┌────────────────────────────────────────────────────────────┐
│ Domain                                                     │
│ Entities, repository protocols, use cases                  │
│ No SwiftUI, URLSession, FileManager, or vendor SDK imports │
└────────────────────────────────────────────────────────────┘
```

Dependencies point inward. Domain never imports Data or Presentation. Data never imports Presentation.

## Request flow

### Show list

1. `ShowsListView` emits an action.
2. `ShowsListModel` coordinates presentation state.
3. `FetchShows` or `RefreshShows` invokes `ShowsRepository`.
4. `ShowsRepositoryLive` applies fresh-cache, network, and stale-cache fallback policy.
5. `LiveShowsRemoteDataSource` calls `/shows?page={page}`.
6. `ShowsMapper` converts external DTOs or cache records into `TVShow` entities.
7. The main-actor model updates `LoadState<[TVShow]>`.
8. SwiftUI renders the matching state.

### Show detail

1. `AppRouter` navigates with a show ID, not a partially populated list object.
2. `ShowDetailModel` calls `FetchShowDetail`.
3. The remote source requests the main show with embedded episodes and cast while requesting seasons concurrently.
4. The repository maps and caches one complete `TVShowDetail`.
5. Presentation renders summary HTML, cast, seasons, and episodes grouped by season.
6. `ShareLink` receives a plain-text payload produced from the loaded entity.

## State placement

Reusable primitives are deliberately outside the feature:

```text
Core/State/LoadState.swift
Core/Errors/AppError.swift
Core/DesignSystem/LoadingStateView.swift
Core/DesignSystem/EmptyStateView.swift
Core/DesignSystem/ErrorStateView.swift
```

State with screen meaning remains beside its screen:

```text
Features/Shows/Presentation/List/ShowsListState.swift
Features/Shows/Presentation/Detail/ShowDetailState.swift
```

This avoids an unbounded `Utils` folder while preserving reuse.

## Responsibilities

### App

- Own startup, typed navigation, and dependency composition.
- Construct live dependencies once in `AppContainer`.
- Keep feature behavior out of the composition root.

### Core

- Hold small technical capabilities shared across features.
- Never import a concrete feature.
- Keep generic state and reusable UI configurable.

### Domain

- Model business language with value types.
- Define repository capabilities as protocols.
- Give meaningful operations dedicated use cases.
- Remain independent of UI, transport, cache, and external schemas.

### Data

- Implement Domain protocols.
- Isolate TVMaze JSON and filesystem formats in DTOs and records.
- Map explicitly at boundaries.
- Use actors for shared I/O and repository coordination.
- Treat write-cache failures as non-fatal and stale cache as an offline fallback.

### Presentation

- Keep views declarative and models on the main actor.
- Represent complete screen state explicitly.
- Never call URLSession or FileManager directly.
- Convert HTML only for presentation and sharing.

## Copying the master feature

When adding another feature:

1. Copy `Features/Shows` and rename its business types.
2. Define Domain entities and repository capabilities first.
3. Add DTOs, records, mapping, and the live repository in Data.
4. Add feature state, observable models, and views in Presentation.
5. Register the live dependency and model factories in `AppContainer`.
6. Add a typed `AppRoute` case.
7. Mirror the unit-test structure using protocol-based stubs.

Do not move feature-only types into Core merely to reduce duplication. Promote a type only after it is genuinely reusable.

