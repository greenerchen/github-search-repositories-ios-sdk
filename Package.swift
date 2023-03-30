// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "GitHubSearchRepositories",
    platforms: [
        .macOS(.v13),
    ],
    products: [
        .library(name: "GitHubSearchRepositories", targets: ["GitHubSearchRepositories"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "GitHubSearchRepositories"),
        .testTarget(
            name: "GitHubSearchRepositoriesTests",
            dependencies: ["GitHubSearchRepositories"]),
    ]
)

