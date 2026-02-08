# SwiftForgejo

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Flaosb%2FSwiftForgejo%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/laosb/SwiftForgejo)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Flaosb%2FSwiftForgejo%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/laosb/SwiftForgejo)

A Swift client for Forgejo, generated from its Swagger spec.

## Usage

Add the package to your `Package.swift` file:

```swift
dependencies: [
  .package(url: "https://github.com/laosb/SwiftForgejo.git", exact: "2.0.0+forgejo-11.0.10-gitea-1.22.0")
]
```

Note that due to the inherent use case of this package, likely you will want to use an exact version match to ensure compatibility with your Forgejo instance. Major version bumps (before the `+`) will indicate our own breaking changes, or Forgejo ever releases a new major API version. We will **not** guarantee source compatibility of generated code between minor or patch versions. The build metadata (after the `+`) will track the version of Forgejo the API spec was generated from.

Currently we only track **LTS** versions of Forgejo as we use only LTS versions, and Forgejo OpenAPI schema is only available in deployed instances. Many LTS versions have no changes in OpenAPI schema, so in that case we might update `main` without releasing new versions.

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

Import and use the package in your Swift code. Note that you should pick an OpenAPI transport that suits your environment. Here we use [`OpenAPIAsyncHTTPClient`](https://github.com/swift-server/swift-openapi-async-http-client) as an example, but you can also use other transports. For example, [`OpenAPIURLSession`](https://github.com/apple/swift-openapi-urlsession) uses `URLSession` from `Foundation`, which is preferred on Apple platforms.

An authentication middleware is also provided to ease Forgejo authentication. See [documentation](https://swiftpackageindex.com/laosb/SwiftForgejo/main/documentation/swiftforgejo) for more details.

```swift
import Forgejo
import OpenAPIAsyncHTTPClient

let url = URL(string: "https://your-forgejo-instance.com/api/v1")!
let credentials: ForgejoAuthCredentials = .token(token: "You API Token")
// let credentials: ForgejoAuthCredentials = .login(username: "your-username", password: "your-password", totp: "123456")
let transport = AsyncHTTPClientTransport()
let authMiddleware = ForgejoAuthMiddleware(credentials: credentials)

let client = ForgejoClient(serverURL: url, transport: transport, middlewares: [authMiddleware])
```

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

The original Forgejo Swagger 2.0 spec is also licensed under the MIT License.
