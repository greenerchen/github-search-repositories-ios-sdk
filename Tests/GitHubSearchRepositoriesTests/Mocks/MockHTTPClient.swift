//
//  MockHTTPClient.swift
//  ModelDecodingTests
//
//  Created by Greener Chen on 2022/10/23.
//

import Foundation
@testable import GitHubSearchRepositories

class MockHTTPClient: HTTPClientProtocol {
    var getUrlCallCount = 0
    var getUrlParameters = [(url: URL, completion: (Result<Data, Error>) -> Void)]()
    var stubbedResult: Result<Data, Error>!
    
    func get(url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        getUrlCallCount += 1
        getUrlParameters.append((url, completion))
        completion(stubbedResult)
    }
}

