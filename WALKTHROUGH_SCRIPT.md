# Five-Minute Walkthrough Script

This is a recording aid. Keep the final video under five minutes and speak naturally rather than reading every sentence.

## 0:00-0:20 - Introduction

- Introduce yourself and the TV Shows app.
- State that it is built with SwiftUI and the TVMaze API.
- Mention that the repository uses a feature-first Clean Architecture slice.

## 0:20-1:35 - Demonstrate the app

- Launch the app and briefly show the loading state.
- Scroll vertically through the featured show, ranked rail, genre collections, and browse-all grid.
- Search by a show title or genre.
- Open a show and point out the original poster, title, rating, premiere date, cleaned/rendered summary, seasons, episodes, and cast.
- Trigger the native Share action and show that title, plain-text summary, and URL are included.
- Switch between English and Indonesian using the flag menu.

## 1:35-2:05 - Demonstrate the error state

- Stop the app.
- Disable the Mac network or choose a safe method that makes the API unavailable.
- Relaunch or retry after clearing/reinstalling the app if cached data prevents the error state.
- Show the localized error message and Retry button.
- Restore the connection and demonstrate a successful retry.

Do not spend recording time troubleshooting. Rehearse this sequence once, especially the cache behavior, before making the final recording.

## 2:05-3:45 - Explain one file you are proud of

Recommended file: `SwiftBoilerplate/Features/Shows/Data/Repositories/ShowsRepositoryLive.swift`.

Walk through it in this order:

1. The repository is an `actor`, protecting shared cache/network coordination.
2. It depends on remote and local data-source protocols rather than concrete APIs.
3. A fresh cache is returned without unnecessary network work.
4. Network DTOs are explicitly mapped into domain entities.
5. Cache writing is intentionally non-fatal.
6. Stale cached content becomes a fallback when the network fails.
7. A page-after-zero HTTP 404 ends optional pagination cleanly.
8. Detail loading follows the same policy and returns a complete domain entity.

Connect the file back to the dependency rule: Presentation calls a use case, the use case knows the Domain repository protocol, and this Data type implements it.

## 3:45-4:35 - Show an AI mistake and correction

Use the horizontal viewport bug because it is visual and easy to explain:

- Explain that the first AI-assisted redesign compiled and looked rich, but simulator testing showed that the whole screen could move sideways.
- Show commit `d766310` or its diff.
- Explain that root screens were constrained to the viewport, screen scrolling was made explicitly vertical, and only content rails remained horizontal.
- State that this demonstrated why AI output still needs device testing.

Alternative: show commit `3e3d35c` and explain the `Int`/helper name collision.

## 4:35-4:55 - Tests and close

- Briefly open the test navigator or the successful GitHub Actions run.
- Mention coverage for nullable API fields, mapping, HTML cleanup, caching/offline fallback, screen states, localization, sharing, and launch.
- Close by naming one future improvement, such as screenshot and accessibility tests.

## Before uploading

- Confirm the recording is under five minutes.
- Confirm screen text is readable and no notification or credential appears.
- Set link access so anyone with the link can view it.
- Replace the placeholder in `README.md` with the final URL.
