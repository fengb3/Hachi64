// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Hachi64",
    products: [
        .library(
            name: "Hachi64",
            targets: ["Hachi64"]),
    ],
    targets: [
        .target(
            name: "Hachi64",
            dependencies: []),
        .testTarget(
            name: "Hachi64Tests",
            dependencies: ["Hachi64"]),
    ]
)
