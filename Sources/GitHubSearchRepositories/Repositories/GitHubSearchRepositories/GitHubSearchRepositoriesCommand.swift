//
//  GitHubSearchRepositoriesCommand.swift
//  GitHubSearchRepositories
//
//  Created by Greener Chen on 2022/10/23.
//

import Foundation

protocol Command {
    var httpClient: HTTPClientProtocol { get set }
    func execute()
}

protocol GitHubSearchRepositoriesCommandProtocol: Command {
    var baseUrl: URL { get }
    var platform: Platform { get }
    var organization: String { get }
    var completion: ((Result<[GithubRepository], Error>) -> Void)? { get set }
}

public struct GitHubSearchRepositoriesCommand: GitHubSearchRepositoriesCommandProtocol {
    var baseUrl: URL
    var platform: Platform
    var organization: String
    var completion: ((Result<[GithubRepository], Error>) -> Void)?
    var httpClient: HTTPClientProtocol = {
        HTTPClient()
    }()
    
    func execute() {
        var url: URL = baseUrl
        if #available(macOS 13.0, *) {
            url = baseUrl.appending(queryItems: [
                URLQueryItem(name: "q", value: platform.rawValue),
                URLQueryItem(name: "org", value: organization)
            ])
        } else {
            // Fallback on earlier versions
        }
        httpClient.get(url: url) { result in
            switch result {
            case .success(let data):
                do {
                    let models: [GithubRepository] = try GithubRepositoryMapper().map(data: data)
                    completion?(.success(models))
                } catch {
                    completion?(.failure(error))
                }
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
}
