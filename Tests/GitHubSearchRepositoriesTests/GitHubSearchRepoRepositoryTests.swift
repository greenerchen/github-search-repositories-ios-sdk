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
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertEqual(sut.client.getUrlCallCount, 1)
        XCTAssertEqual(sut.client.getUrlParameters[0].url, URL(string: "http://a-url.com?q=ios&org=google")!)
    }
    
    func test_searchCallsTwice_expectTwoUrlsFormed() {
        let url = URL(string: "http://a-url.com")!
        let sut = makeSUT(url: url)
        sut.client.stubbedResult = .success(Data())
        
        let exp1 = expectation(description: "Wait for completion")
        sut.repository.searchRepositories(withPlatform: .ios, inOrganization: "google") { result in
            exp1.fulfill()
        }
        let exp2 = expectation(description: "Wait for completion")
        sut.repository.searchRepositories(withPlatform: .android, inOrganization: "meta") { result in
            exp2.fulfill()
        }
        wait(for: [exp1, exp2], timeout: 1.0)
        
        XCTAssertEqual(sut.client.getUrlCallCount, 2)
        XCTAssertEqual(sut.client.getUrlParameters[0].url, URL(string: "http://a-url.com?q=ios&org=google")!)
        XCTAssertEqual(sut.client.getUrlParameters[1].url, URL(string: "http://a-url.com?q=android&org=meta")!)
    }
    
    func test_invalidJSONResponse_expectDecodingError() {
        let invalidJson = Data(StubJsonFactory.makeInvalidJsonString().utf8)
        let sut = makeSUT()
        sut.client.stubbedResult = .success(invalidJson)
        
        let exp = expectation(description: "Wait for completion")
        sut.repository.searchRepositories(withPlatform: .ios, inOrganization: "google") { result in
            switch result {
            case let .failure(error):
                XCTAssertNotNil(error)
            default:
                XCTFail("Expected failure with decoding error, but got success instead")
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_repositoryItemsJSONResponse_expectRepositoryItemsResult() {
        let response = Data(StubJsonFactory.makeExampleResponseJsonString().utf8)
        let sut = makeSUT()
        sut.client.stubbedResult = .success(response)
        
        let exp = expectation(description: "Wait for completion")
        sut.repository.searchRepositories(withPlatform: .ios, inOrganization: "google") { result in
            switch result {
            case let .success(repos):
                XCTAssertTrue(repos.count == 1, "\(repos)")
                XCTAssertEqual(repos[0].name, "Tetris")
                XCTAssertEqual(repos[0].isPrivate, false)
                XCTAssertEqual(repos[0].repoDescription, "A C implementation of Tetris using Pennsim through LC4")
                XCTAssertEqual(repos[0].language, "Assembly")
            default:
                XCTFail("Expected success, but got failure instead")
            }
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
