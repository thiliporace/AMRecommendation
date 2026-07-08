# AMRecommendation

iOS app that displays Top Artists, Top Tracks, Recently Played Artists and Artists' profiles by consuming the [Spotify Web API](https://developer.spotify.com/documentation/web-api).

---

## iOS Architecture

- **MVVM-C (Model-View-ViewModel-Coordinator)** — Views and ViewModels handle presentation, state and API requests, while Coordinators own navigation flow.
- **Clean Architecture** — Clear separation between layers (Presentation, Domain, Data) with Dependency Inversion. 

---

## UI & Design

- **UIKit** — The entire interface is built programmatically with UIKit.
- **Design System** — Reusable, centralized UI components.
- **SDUI (Server-Driven UI)** — Certain components are rendered dynamically from a JSON file.
- **Dynamic Type** - Built-in accessibility support ensuring all typography scales fluidly according to the user's system-wide font size preferences without breaking layouts.

---

## Language & Concurrency

- **Swift 6** — Latest Swift version.
- **Swift Concurrency** — Uses `async/await`, actors, and structured concurrency for asynchronous work.

---

## Design Patterns

- **Delegation**
- **Observer**
- **Coordinator**

---

## Testing

- **Unit Testing** — Coverage for ViewModels, use cases, and business logic.
- **Snapshot Testing** — Visual regression testing for UI components via [swift-snapshot-testing](https://github.com/pointfreeco/swift-snapshot-testing).
- **Swift Testing** — Modern test suites using the new `Testing` framework.
- **XCTest** — Used for XCUIAutomation.
- **Stubs & Mocks** — Test doubles isolate units under test and make network/dependency behavior deterministic.

---

## Dependencies

All dependencies are managed via **SPM (Swift Package Manager)**:

| Package | Purpose |
|---|---|
| [Kingfisher](https://github.com/onevcat/Kingfisher) | Asynchronous image downloading & caching |
| [swift-snapshot-testing](https://github.com/pointfreeco/swift-snapshot-testing) | Snapshot/visual regression testing |

---

## CI/CD & Distribution

- **GitHub Actions** — Continuous integration pipeline.
- **AltStore** — Used for sideloading and distributing the app to devices outside the App Store.

---

## How to get started

1. Clone the repository.
2. Open the project in Xcode.
3. Resolve Swift Package Manager dependencies.
4. Copy Secrets.example.xcconfig to Secrets.xcconfig, move it to AMRecommendation and fill in your Spotify credentials. This file is listed in .gitignore and must never be committed.
5. Build and run.

> Note: Accessing the Spotify Web API requires a Spotify app registered in the Spotify Developer Dashboard (providing a Client ID and Client Secret), and the app owner must have an active Spotify Premium subscription for Development Mode access. Xcode 26 with macOS Tahoe and iOS 15.6 for the build target are required.
