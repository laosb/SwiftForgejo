# SwiftForgejo

A Swift client for Forgejo, generated from its Swagger spec.

## Usage

Add the package to your `Package.swift` file:

```swift
dependencies: [
  .package(url: "https://github.com/laosb/SwiftForgejo.git", exact: "1.0.0+forgejo-11.0.3-gitea-1.22.0")
]
```

Note that due to the inherent use case of this package, likely you will want to use an exact version match to ensure compatibility with your Forgejo instance. Major version bumps (before the `+`) will indicate our own breaking changes, or Forgejo ever releases a new major API version. We will **not** guarantee source compatibility of generated code between minor or patch versions. The build metadata (after the `+`) will track the version of Forgejo the API spec was generated from.

Add the dependency to your target:

```swift
targets: [
  .target(
    name: "YourTarget",
    dependencies: [
      .product(name: "Forgejo", package: "SwiftForgejo")
    ]
  )
]
```

Import and use the package in your Swift code:

```swift
import Forgejo

let client = ForgejoClient(
  url: URL(string: "https://your-forgejo-instance.com/api/v1")!,
  credentials: .token(token: "You API Token"), // optional
  // credentials: .login(username: "your-username", password: "your-password", totp: "123456"),
)
```

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

The original Forgejo Swagger 2.0 spec is also licensed under the MIT License.
