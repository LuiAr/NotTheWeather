// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WeatherCompare",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "WeatherCompare",
            targets: ["WeatherCompare"]),
    ],
    targets: [
        .target(
            name: "WeatherCompare",
            dependencies: []
        )
    ]
)
