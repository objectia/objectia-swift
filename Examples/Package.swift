// swift-tools-version:4.0 
import PackageDescription

let package = Package(
    name: "Example",
    products: [
        .library(
            name: "Example",
            targets: ["Example"]),
    ],
    dependencies: [
        .package(url: "https://github.com/objectia/objectia-swift.git", .upToNextMajor(from: "0.0.1"))
    ],
    targets: [
        .target(
            name: "Example",
            dependencies: ["Objectia"])
    ]
)