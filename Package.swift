// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Basel",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "Basel",
            targets: ["Basel"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/OpenParkingApp/Datasource.git", .upToNextMinor(from: "0.7.0")),
        .package(url: "https://github.com/sharplet/Regex", from: "2.1.0"),
        .package(url: "https://github.com/nmdias/FeedKit", from: "8.1.1"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "Basel",
            dependencies: ["Datasource", "FeedKit", "Regex"]),
        .testTarget(
            name: "BaselTests",
            dependencies: [
                "Basel",
                .product(name: "DatasourceValidation", package: "Datasource"),
            ]),
    ]
)
