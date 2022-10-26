//
//  GitHubSearchRepositoriesCommandFactory.swift
//  ModelDecodingTests
//
//  Created by Greener Chen on 2022/10/26.
//

import Foundation
@testable import GitHubSearchRepositories

enum GitHubSearchRepositoriesCommandFactory {
    static func makeCommand(withHTTPClient httpClient: HTTPClientProtocol) -> GitHubSearchRepositoriesCommand {
        GitHubSearchRepositoriesCommand(
            baseUrl: URL(string: "https://api.github.com/search/repositories")!,
            platform: Platform.android,
            organization: "rainbow",
            httpClient: httpClient
        )
    }
}
