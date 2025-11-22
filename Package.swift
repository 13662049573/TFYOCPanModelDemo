// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "TFYOCPanlModel",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "TFYOCPanlModel",
            type: .static,
            targets: ["TFYOCPanlModel"]
        )
    ],
    targets: [
        .target(
            name: "TFYOCPanlModel",
            path: "TFYOCPanModelDemo/TFYOCPanlModel",
            sources: [
                "Tools",
                "popController", 
                "popView",
                "include"
            ],
            publicHeadersPath: "include",        // 关键：告诉 SPM 公共头文件在 include
            cSettings: [
                .headerSearchPath("include"),
                .headerSearchPath("Tools"),
                .headerSearchPath("popController"),
                .headerSearchPath("popView")
            ]
        )
    ]
)