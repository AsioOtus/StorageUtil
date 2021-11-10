// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "StorageUtil",
    products: [
        .library(
            name: "StorageUtil",
            targets: ["StorageUtil"]
		),
    ],
    targets: [
        .target(
            name: "StorageUtil"
		),
        .testTarget(
            name: "StorageUtilTests",
            dependencies: ["StorageUtil"]
		),
    ]
)
