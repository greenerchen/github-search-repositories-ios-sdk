//
//  HTTPClient.swift
//  GitHubSearchRepositories
//
//  Created by Greener Chen on 2022/10/23.
//

import Foundation

public protocol HTTPClientProtocol {
    func get(url: URL, completion: @escaping (Result<Data, Error>) -> Void)
}

enum HTTPRequestError: Error, Equatable {
    case statusCodeNotOk(code: Int)
    case corruptedData
}

class HTTPClient: HTTPClientProtocol {
    private let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func get(url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) { [completion] data, urlResponse, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            let httpUrlResponse = urlResponse as! HTTPURLResponse
            guard httpUrlResponse.statusCode == 200 else {
                completion(.failure(HTTPRequestError.statusCodeNotOk(code: httpUrlResponse.statusCode)))
                return
            }
            guard let data = data else {
                completion(.failure(HTTPRequestError.corruptedData))
                return
            }
            completion(.success(data))
        }
        task.resume()
    }
}
