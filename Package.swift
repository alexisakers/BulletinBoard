// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "BLTNBoard",
    platforms: [.iOS(.v9)],
    products: [
        .library(name: "BLTNInterfaceBuilder", targets: ["BLTNInterfaceBuilder"]),
        .library(name: "BLTNModels", targets: ["BLTNModels"]),
        .library(
            name: "BLTNBoard",
            targets: ["BLTNBoard"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "BLTNInterfaceBuilder",
            dependencies: [],
            path: "Sources/InterfaceBuilder"
        ),
        .target(
            name: "BLTNModels",
            dependencies: ["BLTNInterfaceBuilder"],
            path: "Sources/Models"
        ),
        .target(
            name: "BLTNBoard",
            dependencies: ["BLTNInterfaceBuilder", "BLTNModels"],
            path: "Sources",
            exclude: ["InterfaceBuilder", "Models"]
        ),
    ]
)
