// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Logger",    
    defaultLocalization: "en",
    platforms: [
        .iOS(.v10),
        .macOS(.v12),
        .macCatalyst(.v13),
    ],
    products: [
        .library(
            name: "Logger",
            targets: ["Logger"]),
    ],
    dependencies: [
//        .package(path: "../Additive"),
//        .package(path: "../Mocks"),
        .package(url: "http://pubgi.fanapsoft.ir/chat/ios/additive.git", exact: "1.0.1"),
        .package(url: "http://pubgi.fanapsoft.ir/chat/ios/mocks.git", exact: "1.0.1"),
    ],
    targets: [
        .target(
            name: "Logger",
            dependencies: [
                .product(name: "Additive", package: "additive"),
            ],
            resources: [.process("Resources")]
        ),
        .testTarget(
            name: "LoggerTests",
            dependencies: ["Logger", .product(name: "Mocks", package: "mocks"), .product(name: "Additive", package: "additive")]),
    ]
)
