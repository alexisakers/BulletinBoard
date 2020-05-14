// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "BLTNBoard",
    products: [
        .library(
            name: "BLTNBoard",
            targets: ["BLTNBoard"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "BLTNBoard",
            dependencies: [],
            path: "Sources"),
    ]
)
