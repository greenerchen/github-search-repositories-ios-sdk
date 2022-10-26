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
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_givenFullRequiredPropertiesJson_expectDecodingSucceeds() throws {
        let exp = expectation(description: "Decoding")
        let stubbedJson = StubJsonFactory.makeFullRequirePropertiesJsonString()
        let mockHTTPClient = MockHTTPClient(stubbedJson: stubbedJson)
        sut = GitHubSearchRepositoriesCommandFactory.makeCommand(withHTTPClient: mockHTTPClient)
        sut.completion = { result in
            switch result {
            case .success(let repos):
                XCTAssertTrue(repos.count == 2, "\(repos)")
                for (index, repo) in repos.enumerated() {
                    if index == 0 {
                        XCTAssertEqual(repo.name, "stub-1")
                        XCTAssertEqual(repo.isPrivate, false)
                        XCTAssertEqual(repo.repoDescription, "stub description 1")
                        XCTAssertEqual(repo.language, "Kotlin")
                    } else {
                        XCTAssertEqual(repo.name, "stub-2")
                        XCTAssertEqual(repo.isPrivate, true)
                        XCTAssertEqual(repo.repoDescription, "stub description 2")
                        XCTAssertEqual(repo.language, "Java")
                    }
                }
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            exp.fulfill()
        }
        sut.execute()
        wait(for: [exp], timeout: 10)
    }
    
    func test_givenPartialRequiredPropertiesJson_expectDecodingSucceeds() throws {
        let exp = expectation(description: "Decoding")
        let stubbedJson = StubJsonFactory.makePartialRequirePropertiesJsonString()
        let mockHTTPClient = MockHTTPClient(stubbedJson: stubbedJson)
        sut = GitHubSearchRepositoriesCommandFactory.makeCommand(withHTTPClient: mockHTTPClient)
        sut.completion = { result in
            switch result {
            case .success(let repos):
                XCTAssertTrue(repos.count == 2, "\(repos)")
                for (index, repo) in repos.enumerated() {
                    if index == 0 {
                        XCTAssertEqual(repo.name, "stub-1")
                        XCTAssertEqual(repo.isPrivate, false)
                        XCTAssertEqual(repo.repoDescription, "stub description 1")
                        XCTAssertEqual(repo.language, "Kotlin")
                    } else {
                        XCTAssertEqual(repo.name, "stub-2")
                        XCTAssertEqual(repo.isPrivate, true)
                        XCTAssertEqual(repo.repoDescription, "")
                        XCTAssertEqual(repo.language, "Java")
                    }
                }
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            exp.fulfill()
        }
        sut.execute()
        wait(for: [exp], timeout: 10)
    }

    func test_givenInvalidJson_expectDecodingFailed() throws {
        let exp = expectation(description: "Decoding")
        let stubbedJson = StubJsonFactory.makeInvalidJsonString()
        let mockHTTPClient = MockHTTPClient(stubbedJson: stubbedJson)
        sut = GitHubSearchRepositoriesCommandFactory.makeCommand(withHTTPClient: mockHTTPClient)
        sut.completion = { result in
            switch result {
            case .success(let repos):
                XCTFail("Expect to get and error")
            case .failure(let error):
                XCTAssertNotNil(error)
            }
            exp.fulfill()
        }
        sut.execute()
        wait(for: [exp], timeout: 10)
    }
}

