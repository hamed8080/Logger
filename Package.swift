// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let useLocalDependency = true

let local: [Package.Dependency] = [
    .package(path: "../Additive"),
    .package(path: "../Mocks"),
    .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0"),
]

let remote: [Package.Dependency] = [
    .package(url: "https://pubgi.sandpod.ir/chat/ios/additive", from: "1.2.3"),
    .package(url: "https://pubgi.sandpod.ir/chat/ios/mocks", from: "1.2.4"),
    .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0"),
]

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
    dependencies: useLocalDependency ? local : remote,
    targets: [
        .target(
            name: "Logger",
            dependencies: [
                .product(name: "Additive", package: useLocalDependency ? "Additive" : "additive"),
                .product(name: "Mocks", package: useLocalDependency ? "Mocks" : "mocks"),
            ]
        ),
        .testTarget(
            name: "LoggerTests",
            dependencies: [
                .product(name: "Additive", package: useLocalDependency ? "Additive" : "additive"),
                .product(name: "Mocks", package: useLocalDependency ? "Mocks" : "mocks"),
                "Logger",
            ]
        ),
    ]
)
