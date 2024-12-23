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
        let (_, session) = makeSUT()
        
        XCTAssertEqual(session.requestedURLs, [])
    }
    
    func test_get_UrlRequested() {
        let url = URL(string: "https://a.com")!
        let (sut, session) = makeSUT()
        
        expect(sut, session: session, whenRequestURL: url, resultRequestedURLs: [url])
    }
    
    func test_getTwice_TwoUrlsRequested() {
        let url = URL(string: "https://a.com")!
        let (sut, session) = makeSUT()
        
        expect(sut, session: session, whenRequestURL: url, resultRequestedURLs: [url])
        expect(sut, session: session, whenRequestURL: url, resultRequestedURLs: [url, url])
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: HTTPClient, session: URLSessionSpy) {
        let session = URLSessionSpy()
        let client = HTTPClient(session: session)
        return (client, session)
    }
    
    private func expect(_ sut: HTTPClient, session: URLSessionSpy, whenRequestURL url: URL, resultRequestedURLs: [URL], file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for response")
        
        sut.get(url: url) { _ in
            XCTAssertEqual(session.requestedURLs, resultRequestedURLs, file: file, line: line)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 3)
    }
    
    final class URLSessionSpy: URLSession {
        var requestedURLs = [URL]()
        
        private let session = URLSessionSpy.shared
        
        override func dataTask(with request: URLRequest, completionHandler: @escaping @Sendable (Data?, URLResponse?, (any Error)?) -> Void
        ) -> URLSessionDataTask {
            requestedURLs.append(request.url!)
            return session.dataTask(with: request, completionHandler: completionHandler)
        }
    }
}
