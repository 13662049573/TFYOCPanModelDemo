// swift-tools-version:5.9
// 注意：这一行必须干净，不能有任何注释或空格在版本号后面！！！

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
                "include",
                "Tools",
                "popController",
                "popView"
            ],
            publicHeadersPath: "include",
            cSettings: [
                // 常规搜索路径
                .headerSearchPath(""),
                .headerSearchPath("include"),
                .headerSearchPath("Tools"),
                .headerSearchPath("popController"),
                .headerSearchPath("popView"),

                // 终极杀招：用纯相对路径 -I，彻底绕过 Xcode 对变量的限制
                .unsafeFlags(["-I", "."]),
                .unsafeFlags(["-I", "TFYOCPanModelDemo/TFYOCPanlModel"]),
                .unsafeFlags(["-I", "TFYOCPanModelDemo/TFYOCPanlModel/include"]),
                .unsafeFlags(["-I", "TFYOCPanModelDemo/TFYOCPanlModel/Tools"]),
                .unsafeFlags(["-I", "TFYOCPanModelDemo/TFYOCPanlModel/popController"]),
                .unsafeFlags(["-I", "TFYOCPanModelDemo/TFYOCPanlModel/popView"])
            ]
        )
    ]
)