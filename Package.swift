// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "GitHubSearchRepositories",
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

