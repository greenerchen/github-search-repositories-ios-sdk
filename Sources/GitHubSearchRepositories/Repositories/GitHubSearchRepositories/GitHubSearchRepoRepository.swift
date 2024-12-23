//
//  GitHubSearchRepoRepository.swift
//  GitHubSearchRepositories
//
//  Created by Greener Chen on 2022/10/23.
//

import Foundation
import Combine

protocol Repository {
    var client: HTTPClientProtocol { get set }
    var url: URL { get set }
}

protocol GitHubSearchRepoProtocol: Repository {
    func searchRepositories(withPlatform platform: Platform, inOrganization organization: String, completion: ((Result<[GithubRepository], Error>) -> Void)?)
    /// Support Combine
    func searchRepositories(withPlatform platform: Platform, inOrganization organization: String) -> Future<[GithubRepository], Error>
    /// Modern Concurrency
    func searchRepositories(withPlatform platform: Platform, inOrganization organization: String) async ->
    Result<[GithubRepository], Error>
}

public enum Platform: String {
    case android
    case ios
}

public class GitHubSearchRepoRepository: GitHubSearchRepoProtocol {
    var url: URL
    var client: HTTPClientProtocol
    
    init(url: URL = URL(string: "https://api.github.com/search/repositories")!, client: HTTPClientProtocol = HTTPClient()) {
        self.url = url
        self.client = client
    }
    
    public func searchRepositories(withPlatform platform: Platform, inOrganization organization: String, completion: ((Result<[GithubRepository], Error>) -> Void)?) {
        let url = self.url.appending(queryItems: [
            URLQueryItem(name: "q", value: platform.rawValue),
            URLQueryItem(name: "org", value: organization)
        ])
        client.get(url: url) { result in
            switch result {
            case .success(let data):
                do {
                    let repos: [GithubRepository] = try GithubRepositoryMapper().map(data: data)
                    completion?(.success(repos))
                } catch {
                    completion?(.failure(error))
                }
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
    
    public func searchRepositories(withPlatform platform: Platform, inOrganization organization: String) -> Future<[GithubRepository], Error> {
        Future { promise in
            self.searchRepositories(withPlatform: platform, inOrganization: organization) { result in
                promise(result)
            }
        }
    }
    
    public func searchRepositories(withPlatform platform: Platform, inOrganization organization: String) async ->
    Result<[GithubRepository], Error> {
        await withCheckedContinuation { continuation in
            self.searchRepositories(withPlatform: platform, inOrganization: organization) { result in
                continuation.resume(returning: result)
            }
        }
    }
}
