// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "AnimatableMacro",
    platforms: [.macOS(.v10_15), .iOS(.v15), .tvOS(.v13), .watchOS(.v6), .macCatalyst(.v13)],
    products: [
        .library(
            name: "AnimatableMacro",
            targets: ["AnimatableMacro"]
        ),
        .library(
            name: "Utilities",
            targets: ["Utilities"]
        ),
        .executable(
            name: "AnimatableMacroClient",
            targets: ["AnimatableMacroClient"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "600.0.0-latest"),
        .package(url: "https://github.com/pointfreeco/swift-macro-testing", from: "0.4.0")
    ],
    targets: [
        .macro(
            name: "AnimatableMacroMacros",
            dependencies: [
                "Utilities",
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftSyntaxBuilder", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ]
        ),
        .target(
            name: "Utilities",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftSyntaxBuilder", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ]
        ),
        .target(
            name: "AnimatableMacro",
            dependencies: [
                "AnimatableMacroMacros",
                "Utilities"
            ]
        ),
        .testTarget(
            name: "AnimatableMacroTests",
            dependencies: [
                "AnimatableMacro",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
                .product(name: "MacroTesting", package: "swift-macro-testing")
            ]
        ),
        
        .executableTarget(name: "AnimatableMacroClient", dependencies: ["AnimatableMacro"])
        
    ]
)
