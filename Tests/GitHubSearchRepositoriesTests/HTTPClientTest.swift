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
    
    func test_get_requestErrorOnClientError() {
        let clientError = NSError(domain: "client error", code: -1003)
        let (sut, session) = makeSUT()
        
        expect(sut, session: session, url: URL(string: "https://a.com")!, expectedResult: .error(clientError)) {
            session.complete(with: clientError)
        }
    }
    
    func test_get_requestErrorOnClientRequestError() {
        let serviceError = HTTPRequestError.statusCodeNotOk(code: 404)
        let (sut, session) = makeSUT()
        
        expect(sut, session: session, url: URL(string: "https://google.com/abcde")!, expectedResult: .error(serviceError)) {
            session.complete(with: serviceError)
        }
    }
    
    func test_get_requestErrorOnNoDataReceived() {
        let (sut, session) = makeSUT()
        
        expect(sut, session: session, url: URL(string: "https://google.com/abcde")!, expectedResult: .corruptedData) {
            session.complete(with: nil)
        }
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
    
    private enum RequestResult {
        case error(Error)
        case statusCodeNotOk(code: Int)
        case corruptedData
        case succeeded
    }
    
    private func expect(_ sut: HTTPClient, session: URLSessionSpy, url: URL, expectedResult: RequestResult, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for response")
        
        sut.get(url: url) { actualResult in
            switch (actualResult, expectedResult) {
            case let (.failure(actualError), .error(expectedError)) where expectedError is HTTPRequestError:
                XCTAssertEqual(actualError as! HTTPRequestError, expectedError as!  HTTPRequestError, file: file, line: line)
            case let (.failure(actualError), .error(expectedError)):
                XCTAssertEqual((actualError as NSError).code, (expectedError as NSError).code, file: file, line: line)
            default:
                break
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 3)
    }
    
    final class URLSessionSpy: URLSession {
        var requestedURLs = [URL]()
        var completions = [(Data?, URLResponse?, (any Error)?) -> Void]()
        
        private let session = URLSessionSpy.shared
        
        override func dataTask(with request: URLRequest, completionHandler: @escaping @Sendable (Data?, URLResponse?, (any Error)?) -> Void
        ) -> URLSessionDataTask {
            requestedURLs.append(request.url!)
            completions.append(completionHandler)
            return session.dataTask(with: request, completionHandler: completionHandler)
        }
        
        func complete(with error: Error, at index: Int = 0) {
            completions[index](nil, nil, error)
        }
        
        func complete(with data: Data?, at index: Int = 0) {
            completions[index](data, nil, nil)
        }
    }
}
