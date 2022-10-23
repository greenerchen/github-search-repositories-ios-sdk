//
//  MockHTTPClient.swift
//  ModelDecodingTests
//
//  Created by Greener Chen on 2022/10/23.
//

import Foundation
@testable import GitHubSearchRepositories

struct MockHTTPClient: HTTPClientProtocol {
    func get(url: URL, completion: @escaping GitHubSearchRepositories.HTTP_RESPONSE) {
        let stubJson = [
            "items": [
                [
                    "name": "stub-1",
                    "private": false,
                    "description": "stub description 1",
                    "language": "Kotlin"
                ],
                [
                    "name": "stub-2",
                    "private": true,
                    "description": "stub description 2",
                    "language": "Java"
                ]
            ]
        ]
        do {
            let data = try JSONSerialization.data(withJSONObject: stubJson)
            completion(.success(data))
        } catch {
            completion(.failure(error))
        }
    }
}

