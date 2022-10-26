//
//  MockHTTPClient.swift
//  ModelDecodingTests
//
//  Created by Greener Chen on 2022/10/23.
//

import Foundation
@testable import GitHubSearchRepositories

enum MockHTTPClientError: Error {
    case noStubbedJson
}

struct MockHTTPClient: HTTPClientProtocol {
    var stubbedJson: String?
    
    func get(url: URL, completion: @escaping GitHubSearchRepositories.HTTP_RESPONSE) {
        do {
            guard let stubbedJson = stubbedJson else {
                completion(.failure(MockHTTPClientError.noStubbedJson))
                return
            }
            let data = stubbedJson.data(using: .utf8)!
            completion(.success(data))
        } catch {
            completion(.failure(error))
        }
    }
}

