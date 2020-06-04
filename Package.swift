// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "BLTNBoard",
    platforms: [.iOS(.v9)],
    products: [
        .library(name: "BLTNBoard", targets: ["BLTNInterfaceBuilder", "BLTNModels", "BLTNBoard"]),
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
