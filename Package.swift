// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "Jarvis",
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0-rc.2.8.1"),
        .package(url: "https://github.com/vapor/fluent-postgresql.git", from: "1.0.0-rc.2.2.1")
    ],
    targets: [
        .target(name: "App", dependencies: ["FluentPostgreSQL", "Vapor"]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App"])
    ]
)

