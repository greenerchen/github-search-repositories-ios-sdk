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
        
        expect(sut, session: session, url: URL(string: "https://google.com/abcde")!, expectedResult: .statusCodeNotOk(code: 404)) {
            session.complete(with: serviceError)
        }
    }
    
    func test_get_requestErrorOnNoDataReceived() {
        let (sut, session) = makeSUT()
        
        expect(sut, session: session, url: URL(string: "https://google.com")!, expectedResult: .corruptedData) {
            session.complete(with: nil)
        }
    }
    
    func test_get_requestSucceeded() {
        let data = Data("any data".utf8)
        let (sut, session) = makeSUT()
        
        expect(sut, session: session, url: URL(string: "https://google.com")!, expectedResult: .succeeded(data)) {
            session.complete(with: data)
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
        wait(for: [exp], timeout: 5)
    }
    
    private enum RequestResult {
        case error(Error)
        case statusCodeNotOk(code: Int)
        case corruptedData
        case succeeded(Data)
    }
    
    private func expect(_ sut: HTTPClient, session: URLSessionSpy, url: URL, expectedResult: RequestResult, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = XCTestExpectation(description: "Wait for response")
        
        sut.get(url: url) { actualResult in
            switch (actualResult, expectedResult) {
            case let (.success(actualData), .succeeded(expectedData)):
                XCTAssertEqual(actualData, expectedData, file: file, line: line)
            case let (.failure(actualError), .corruptedData):
                XCTAssertEqual(actualError as! HTTPRequestError, .corruptedData, file: file, line: line)
            case let (.failure(actualError), .statusCodeNotOk):
                XCTAssertEqual(actualError as! HTTPRequestError, .statusCodeNotOk(code: 404), file: file, line: line)
            case let (.failure(actualError), .error(expectedError)):
                XCTAssertEqual((actualError as NSError).code, (expectedError as NSError).code, file: file, line: line)
            default:
                break
            }
            exp.fulfill()
        }
        action()
        wait(for: [exp], timeout: 5)
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
        
        func complete(withStatusCode code: Int, at index: Int = 0) {
            let response = HTTPURLResponse(url: URL(string: "https://any-url.com")!, statusCode: code, httpVersion: nil, headerFields: nil)
            completions[index](nil, response, nil)
        }
        
        func complete(with data: Data?, at index: Int = 0) {
            let response = HTTPURLResponse(url: URL(string: "https://any-url.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
            completions[index](data, response, nil)
        }
    }
}
