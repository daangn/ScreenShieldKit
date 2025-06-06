// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "ScreenShieldKit",
  platforms: [.iOS(.v14), .macOS(.v11)],
  products: [
    .library(
      name: "ScreenShieldKit",
      targets: ["ScreenShieldKit"]
    ),
  ],
  targets: [
    .target(
      name: "ScreenShieldKit"
    ),
  ]
)
