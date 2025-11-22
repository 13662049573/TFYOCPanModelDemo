// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "TFYOCPanlModel",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "TFYOCPanlModel",
            targets: ["TFYOCPanlModel"]
        )
    ],
    targets: [
        .target(
            name: "TFYOCPanlModel",
            path: "TFYOCPanModelDemo/Sources/TFYOCPanlModel",
            sources: [
                "include",
                "Tools",
                "popController",
                "popView"
            ],
            cSettings: [
                .headerSearchPath("."),
                .headerSearchPath("Tools"),
                .headerSearchPath("popController"),
                .headerSearchPath("popView"),
                .headerSearchPath("include")
            ]
        )
    ]
)