// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TFYOCPanlModel",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "TFYOCPanlModel",
            type: .static,
            targets: ["TFYOCPanlModel"]
        ),
    ],
    dependencies: [
        // No external dependencies - this library only uses UIKit and Foundation
    ],
    targets: [
        .target(
            name: "TFYOCPanlModel",
            dependencies: [],
            path: "TFYOCPanModelDemo/TFYOCPanlModel",
            sources: [
                "Tools",
                "popController",
                "popView",
                "include",
            ],
            publicHeadersPath: "include",
            cSettings: [
                .headerSearchPath("."),
                .headerSearchPath("include"),
                .headerSearchPath("Tools"),
                .headerSearchPath("popController"),
                .headerSearchPath("popView"),
            ],
            linkerSettings: [
                .linkedFramework("UIKit", .when(platforms: [.iOS])),
                .linkedFramework("Foundation", .when(platforms: [.iOS])),
            ]
        ),
    ],
    cLanguageStandard: .c11
)
