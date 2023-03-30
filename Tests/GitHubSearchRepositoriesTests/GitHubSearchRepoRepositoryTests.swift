//
//  File.swift
//  
//
//  Created by Greener Chen on 2023/3/29.
//

import Foundation

import XCTest
@testable import GitHubSearchRepositories

final class GitHubSearchRepoRepositoryTests: XCTestCase {
    func test_searchCalls_expectUrlWithQueries() {
        let url = URL(string: "http://a-url.com")!
        let sut = makeSUT(url: url)
        sut.client.stubbedResult = .success(Data())
        
        let exp = expectation(description: "Wait for completion")
        sut.repository.searchRepositories(withPlatform: .ios, inOrganization: "google") { result in
            XCTAssertEqual(sut.client.getUrlCallCount, 1)
            XCTAssertEqual(sut.client.getUrlParameters[0].url, URL(string: "http://a-url.com?q=ios&org=google")!)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(url: URL = URL(string: "http://a-url.com")!) -> (repository: GitHubSearchRepoRepository, client: MockHTTPClient) {
        let client = MockHTTPClient()
        let repo = GitHubSearchRepoRepository(url: url, client: client)
        return (repo, client)
    }
}
