//
//  File.swift
//  
//
//  Created by Greener Chen on 2023/3/29.
//

import Foundation

import XCTest
@testable import GitHubSearchRepositories

final class GithubRepositoryMapperTests: XCTestCase {
    func test_givenAllPropertiesJson_expectDecodingSucceeds() {
        let stubbedJson = StubJsonFactory.makeAllPropertiesJsonString()
        
        let sut = GithubRepositoryMapper()
        do {
            let repos = try sut.map(data: Data(stubbedJson.utf8))
            XCTAssertTrue(repos.count == 2, "\(repos)")
            XCTAssertEqual(repos[0].name, "stub-1")
            XCTAssertEqual(repos[0].isPrivate, false)
            XCTAssertEqual(repos[0].repoDescription, "stub description 1")
            XCTAssertEqual(repos[0].language, "Kotlin")
            XCTAssertEqual(repos[1].name, "stub-2")
            XCTAssertEqual(repos[1].isPrivate, true)
            XCTAssertEqual(repos[1].repoDescription, "stub description 2")
            XCTAssertEqual(repos[1].language, "Java")
        } catch {
            XCTFail("Decoding failed, \(error)")
        }
    }
    
    func test_givenExampleResponseJson_expectDecodingSucceeds() {
        let stubbedJson = StubJsonFactory.makeExampleResponseJsonString()
        
        let sut = GithubRepositoryMapper()
        do {
            let repos = try sut.map(data: Data(stubbedJson.utf8))
            XCTAssertTrue(repos.count == 1, "\(repos)")
            XCTAssertEqual(repos[0].name, "Tetris")
            XCTAssertEqual(repos[0].isPrivate, false)
            XCTAssertEqual(repos[0].repoDescription, "A C implementation of Tetris using Pennsim through LC4")
            XCTAssertEqual(repos[0].language, "Assembly")
        } catch {
            XCTFail("Decoding failed, \(error)")
        }
    }
    
    func test_givenEmptyOptionalPropertiesJson_expectDecodingSucceeds() {
        let stubbedJson = StubJsonFactory.makePartialRequirePropertiesJsonString()
        
        let sut = GithubRepositoryMapper()
        do {
            let repos = try sut.map(data: Data(stubbedJson.utf8))
            XCTAssertTrue(repos.count == 2, "\(repos)")
            XCTAssertEqual(repos[0].name, "stub-1")
            XCTAssertEqual(repos[0].isPrivate, false)
            XCTAssertEqual(repos[0].repoDescription, "")
            XCTAssertEqual(repos[0].language, "")
            XCTAssertEqual(repos[1].name, "stub-2")
            XCTAssertEqual(repos[1].isPrivate, true)
            XCTAssertEqual(repos[1].repoDescription, "")
            XCTAssertEqual(repos[1].language, "Java")
        } catch {
            XCTFail("Decoding failed, \(error)")
        }
    }
    
    func test_givenInvalidJson_expectDecodingFailed() {
        let stubbedJson = StubJsonFactory.makeInvalidJsonString()
        
        let sut = GithubRepositoryMapper()
        
        XCTAssertThrowsError(try sut.map(data: Data(stubbedJson.utf8)))
    }
}
