// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Network",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "Network",
            targets: ["Network"]
        ),
    ],
    targets: [
        .target(
            name: "Network",
            dependencies: []
        ),
        .testTarget(
            name: "NetworkTests",
            dependencies: ["Network"]
        ),
    ]
)
