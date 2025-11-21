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
            exclude: [
                "module.modulemap"
            ],
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath("."),
                .headerSearchPath("Animator"),
                .headerSearchPath("Animator/PresentingVCAnimation"),
                .headerSearchPath("Category"),
                .headerSearchPath("Controller"),
                .headerSearchPath("Delegate"),
                .headerSearchPath("KVO"),
                .headerSearchPath("Mediator"),
                .headerSearchPath("popup"),
                .headerSearchPath("Presentable"),
                .headerSearchPath("Presenter"),
                .headerSearchPath("View"),
                .headerSearchPath("View/PanModal"),
            ],
            linkerSettings: [
                .linkedFramework("UIKit", .when(platforms: [.iOS])),
                .linkedFramework("Foundation", .when(platforms: [.iOS])),
            ]
        ),
    ],
    cLanguageStandard: .c11
)

