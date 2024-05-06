// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ZLPhotoBrowser",
    platforms: [.iOS(.v10)],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(name: "ZLPhotoBrowser", targets: ["ZLPhotoBrowser"]),
    ],
    dependencies: [
        .package(url: "https://github.com/SnapKit/SnapKit.git", .upToNextMajor(from: "5.7.1")),
        .package(url: "https://github.com/HeroTransitions/Hero.git", .upToNextMajor(from: "1.6.3")),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "ZLPhotoBrowser",
            dependencies: [
                .product(name: "SnapKit", package: "SnapKit"),
                .product(name: "Hero", package: "Hero"),
            ],
            path: "Sources",
            exclude: [
                "Info.plist",
                "General/ZLWeakProxy.h",
                "General/ZLWeakProxy.m"
            ],
            resources: [
                .process("ZLPhotoBrowser.bundle"),
                .copy("PrivacyInfo.xcprivacy")
            ]
        )
    ]
)
