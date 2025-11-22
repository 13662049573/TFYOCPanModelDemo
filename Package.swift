// swift-tools-version:5.9
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
            // 关键三行：彻底关闭 Objective-C module 构建
            publicHeadersPath: nil,   // 1. 不生成模块头文件映射
            cSettings: nil,           // 2. 不添加任何 cSettings
            linkerSettings: nil       // 3. 关闭 linker 设定
            // 注意：没有 type 参数！这就是导致报错的原因
        )
    ]
)