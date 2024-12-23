//
//  HTTPClientTest.swift
//  GitHubSearchRepositories
//
//  Created by Greener Chen on 2024/12/23.
//

import XCTest
@testable import GitHubSearchRepositories

final class HTTPClientTest: XCTestCase {

    func test_init_noUrlRequested() {
        let (sut, session) = makeSUT()
        
        XCTAssertEqual(session.requestedURLs, [])
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: HTTPClient, session: URLSessionSpy) {
        let session = URLSessionSpy()
        let client = HTTPClient(session: session)
        return (client, session)
    }
    
    final class URLSessionSpy: URLSession {
        var requestedURLs = [URL]()
        
        override func dataTask(with request: URLRequest) -> URLSessionDataTask {
            requestedURLs.append(request.url!)
            return URLSessionSpy.shared.dataTask(with: request)
        }
    }
}
