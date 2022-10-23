GitHubSearchRepositories is a library to search repositories with platform and organization on GitHub.

## Requirements
iOS 16+ \
Swift 5.0+

## Installation

### Swift Package Manager
[Swift Package Manager](https://swift.org/package-manager/) is a tool for managing the distribution of Swift code. It’s integrated with the Swift build system to automate the process of downloading, compiling, and linking dependencies.

To integrate GitHubSearchRepositories into your Xcode project using Swift Package Manager, add it to the dependencies value of your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/greenerchen/GitHubSearchRepositories-ios-spm.git", .upToNextMajor(from: "1.0.0"))
]
```

## Usage
```swift
import GitHubSearchRepositories

struct Demo {
    let repository = GitHubSearchRepoRepository()
    
    func demo() {
        repository.searchRepositories(withPlatform: .ios, inOrganization: "rakutentech") { result in
            switch result {
            case .success(let repos):
                debugPrint(repos)
            case .failure(let error):
                debugPrint(error.localizedDescription)
        }
    }
}
```
