// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "SwiftForgejo",
  platforms: [
    .macOS(.v10_15),
    .iOS(.v13),
    .watchOS(.v6),
    .tvOS(.v13),
  ],
  products: [
    // Products define the executables and libraries a package produces, making them visible to other packages.
    .library(
      name: "Forgejo",
      targets: ["Forgejo"])
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-openapi-generator", from: "1.10.0"),
    .package(url: "https://github.com/apple/swift-openapi-runtime", from: "1.8.0"),
  ],
  targets: [
    .target(
      name: "Forgejo",
      dependencies: [
        .byName(name: "ForgejoAPI")
      ],
    ),
    .target(
      name: "ForgejoAPI",
      dependencies: [
        .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime")
      ],
      exclude: [
        "openapi.json",
        "openapi-generator-config.yaml",
      ]
    ),
    .testTarget(
      name: "ForgejoTests",
      dependencies: ["Forgejo"]
    ),
  ]
)
