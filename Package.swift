// swift-tools-version:5.3

import PackageDescription

let package = Package(
	name: "Multitool",
	platforms: [
		.iOS(.v13),
		.macOS(.v10_15)
	],
	products: [
		.library(
			name: "NetworkUtil",
			targets: ["NetworkUtil"]
		),
		.library(
			name: "UserDefaultsUtil",
			targets: ["UserDefaultsUtil"]
		)
	],
	targets: [
		.target(
			name: "NetworkUtil",
			dependencies: [],
			path: "Utils/NetworkUtil/Source"
		),
		.target(
			name: "UserDefaultsUtil",
			dependencies: [],
			path: "Utils/UserDefaultsUtil/Source"
		)
	],
	swiftLanguageVersions: [.v5]
)
