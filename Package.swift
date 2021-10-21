// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "UserDeaultsUtil",
    products: [
        .library(
            name: "UserDefaultsUtil",
            targets: ["UserDefaultsUtil"]
		),
    ],
    targets: [
        .target(
            name: "UserDefaultsUtil",
            dependencies: []
		),
        .testTarget(
            name: "UserDefaultsUtilTests",
            dependencies: ["UserDefaultsUtil"]
		),
    ]
)
