// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftObjectCache",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "SwiftObjectCache",
            targets: ["SwiftObjectCache"]),
    ],
    targets: [
        .target(
            name: "SwiftObjectCache"),
        .testTarget(
            name: "SwiftObjectCacheTests",
            dependencies: ["SwiftObjectCache"]
        ),
    ]
)
