// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "TFYOCPanlModel",
    platforms: [.iOS(.v15)],
    products: [
        .library(name: "TFYOCPanlModel", targets: ["TFYOCPanlModel"])
    ],
    targets: [
        .target(
            name: "TFYOCPanlModel",
            path: "Sources/TFYOCPanlModel",     // 改成这行！！！
            publicHeadersPath: "Sources/TFYOCPanlModel/include"
        )
    ]
)