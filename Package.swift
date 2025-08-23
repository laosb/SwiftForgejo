// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "SwiftForgejo",
  platforms: [
    .macOS(.v10_15)
  ],
  products: [
    // Products define the executables and libraries a package produces, making them visible to other packages.
    .library(
      name: "Forgejo",
      targets: ["Forgejo"])
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-openapi-generator", from: "1.6.0"),
    .package(url: "https://github.com/apple/swift-openapi-runtime", from: "1.7.0"),
    .package(url: "https://github.com/swift-server/swift-openapi-async-http-client", from: "1.1.0"),
  ],
  targets: [
    .target(
      name: "Forgejo",
      dependencies: [
        .byName(name: "ForgejoAPI"),
        .product(name: "OpenAPIAsyncHTTPClient", package: "swift-openapi-async-http-client"),
      ],
    ),
    .target(
      name: "ForgejoAPI",
      dependencies: [
        .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime")
      ],
      plugins: [
        .plugin(name: "OpenAPIGenerator", package: "swift-openapi-generator")
      ]),
    .testTarget(
      name: "ForgejoTests",
      dependencies: ["Forgejo"]
    ),
  ]
)
