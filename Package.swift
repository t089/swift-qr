// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-qr",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "QR",
            targets: ["QR"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "CQR",
            dependencies: []),
        .target(
            name: "CQRShims",
            dependencies: ["CQR"]),
        .systemLibrary(
            name: "clibpng",
            pkgConfig: "libpng",
            providers: [
                .brew(["libpng"]),
                .apt(["libpng-dev"]),
            ]),
        .target(
            name: "swift-qr-tool",
            dependencies: ["QR"]),
        .target(
            name: "QR",
            dependencies: ["CQR", "CQRShims", "clibpng"]),
        .testTarget(
            name: "QRTests",
            dependencies: ["QR"]),
    ]
)
