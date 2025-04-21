// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "KeyboardExpander",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "KeyboardExpander",
            targets: ["KeyboardExpander"]
        ),
    ],
    targets: [
        .target(
            name: "KeyboardExpander",
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency")
            ]
        ),
    ]
)
