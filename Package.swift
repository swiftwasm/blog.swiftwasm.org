// swift-tools-version:5.8

import PackageDescription

let package = Package(
  name: "SwiftWasmBlog",
  platforms: [
    .macOS(.v12),
  ],
  products: [
    .executable(
      name: "SwiftWasmBlog",
      targets: ["SwiftWasmBlog"]
    ),
  ],
  dependencies: [
    .package(url: "https://github.com/JohnSundell/Publish.git", from: "0.9.0"),
    .package(url: "https://github.com/JohnSundell/SplashPublishPlugin.git", from: "0.2.0"),
    .package(url: "https://github.com/SwiftyGuerrero/CNAMEPublishPlugin", revision: "dab2f15f963578aa08c0dbd90d2b0178e1ee5f90"),
  ],
  targets: [
    .executableTarget(
      name: "SwiftWasmBlog",
      dependencies: [
        "Publish", "SplashPublishPlugin", "CNAMEPublishPlugin",
      ]
    ),
  ]
)
