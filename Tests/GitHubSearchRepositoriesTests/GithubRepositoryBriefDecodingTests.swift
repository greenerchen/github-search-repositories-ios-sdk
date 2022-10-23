//
//  GithubRepositoryBriefDecodingTests.swift
//  ModelDecodingTests
//
//  Created by Greener Chen on 2022/10/23.
//

import XCTest
@testable import GitHubSearchRepositories

final class GithubRepositoryBriefDecodingTests: XCTestCase {

    var sut: GitHubSearchRepositoriesCommandProtocol!
    
    override func setUpWithError() throws {
        let baseUrl = URL(string: "https://api.github.com/search/repositories")!
        sut = GitHubSearchRepositoriesCommand(
            baseUrl: baseUrl,
            platform: Platform.android,
            organization: "anytech",
            httpClient: MockHTTPClient()
        )
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGithubRepositoryBriefDecoding() throws {
        let exp = expectation(description: "Decoding")
        sut.completion = { result in
            switch result {
            case .success(let repos):
                XCTAssertTrue(repos.count == 2, "\(repos)")
                let repo1: GithubRepositoryBrief = repos[0]
                XCTAssertEqual(repo1.name, "stub-1")
                XCTAssertEqual(repo1.isPrivate, false)
                XCTAssertEqual(repo1.repoDescription, "stub description 1")
                XCTAssertEqual(repo1.language, "Kotlin")
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            exp.fulfill()
        }
        sut.execute()
        wait(for: [exp], timeout: 10)
    }
}

