# AI Usage Log

I used ChatGPT/Codex as a development assistant. I remained responsible for the requirements, architectural decisions, review, and verification. The entries below include both useful output and mistakes or limitations I found.

## 1. Translating the assignment into an iOS architecture

**What I asked / problem:** I asked AI to analyze the TVMaze requirements and propose a reusable SwiftUI architecture rather than placing networking directly in a view model.

**What it gave me:** It proposed a feature-first Clean Architecture slice with Domain entities and repository protocols, Data DTOs/data sources/mappers, Presentation models and views, plus an application composition root.

**What I did:** I accepted the overall dependency direction and adapted it to the scope of a one-day exercise. I kept everything in one Xcode target to avoid package setup overhead, but documented the boundaries in `ARCHITECTURE.md`.

**What I verified / AI limitation:** I checked every Domain file to ensure it did not depend on SwiftUI, URLSession, cache records, or DTOs. I also recognized that folder boundaries alone are not compiler-enforced; local Swift packages would be a future improvement.

## 2. Implementing TVMaze mapping and nullable fields

**What I asked / problem:** I asked AI to help model the list and detail responses, including nullable ratings/images/dates, embedded episodes and cast, seasons, and HTML summaries.

**What it gave me:** It generated Codable DTOs, domain entities, explicit mapper functions, and an HTML-to-plain-text conversion boundary.

**What I did:** I retained the explicit DTO-to-domain mapping and added focused tests for null values, date parsing, embedded data, and HTML cleanup.

**What I verified / AI limitation:** I did not assume a successful decode meant the UI was safe. Tests specifically decode a show with a null rating and missing image. I also verified that shared text contains no raw `<b>` tag.

## 3. Fixing a Swift name collision

**What I asked / problem:** The project failed with `Cannot call value of non-function type 'Int'` in cached pagination code.

**What it gave me:** AI traced the error to a helper function whose name collided with a local integer parameter.

**What I did:** I renamed the helper to make its intent unambiguous and kept the parameter name meaningful.

**What AI got wrong / what I verified:** The original generated naming was legal-looking but became ambiguous in context. I verified the correction through the macOS GitHub Actions build and test run instead of accepting the explanation alone. This is recorded in commit `3e3d35c`.

## 4. Improving the streaming-style interface

**What I asked / problem:** I asked AI to improve a basic list into a polished, streaming-inspired interface while preserving clean architecture.

**What it gave me:** It proposed a featured hero, ranked rail, recent-premiere rail, genre collections, adaptive grid, search, shimmer loading, and an immersive detail screen.

**What I did:** I accepted the component decomposition but kept catalog derivation in the pure `BuildShowsCatalog` use case rather than calculating business collections inside SwiftUI views.

**What I verified / AI limitation:** A visually rich design increased layout risk and was not automatically correct on a phone-sized simulator. I later found horizontal viewport behavior that required another iteration and dedicated fix.

## 5. Diagnosing the horizontal viewport bug

**What I asked / problem:** Simulator feedback showed the whole interface could move horizontally, resembling a desktop page viewed on a phone.

**What it gave me:** AI inspected the layout hierarchy and identified unconstrained content in scroll/loading compositions as the likely cause.

**What I did:** I constrained root screens to the device viewport, used explicit vertical scrolling for screen content, and constrained responsive skeleton/card widths while keeping intentional content rails horizontal.

**What AI got wrong / what I verified:** Earlier AI-generated UI did not catch this device-width issue. I treated simulator feedback as authoritative, then verified compilation and the full automated suite after the fix. This is recorded in commit `d766310`.

## 6. Refining localization instead of accepting the first design

**What I asked / problem:** I requested runtime localization with a clean language selector.

**What it gave me:** The first version supported English, Indonesian, and a system-default option using a String Catalog and persisted selection.

**What I did:** I later narrowed the product requirement to exactly English and Indonesian, displayed the active language flag in the toolbar, preserved accessibility labels, and made legacy/invalid saved values safely fall back to English.

**What AI got wrong / what I verified:** The first three-option design was more flexible but did not match the final requirement. I rejected that extra behavior, added assertions for exactly two languages, and verified 15 unit tests plus one UI test in CI. This is recorded in commit `530ade2`.

## 7. Resolving concurrency and animation warnings

**What I asked / problem:** I asked AI to investigate Swift concurrency warnings and a shimmer implementation that could affect layout/runtime behavior.

**What it gave me:** It suggested isolating UI-observable state on the main actor and decoupling shimmer animation from geometry-dependent layout.

**What I did:** I applied the changes in small commits so each correction was reviewable.

**What I verified / AI limitation:** Removing a warning is not enough if behavior changes. I ran the complete test workflow after the concurrency fix and again after the animation/layout refinement. These changes are recorded in commits `425ef3b` and `45fb406`.
