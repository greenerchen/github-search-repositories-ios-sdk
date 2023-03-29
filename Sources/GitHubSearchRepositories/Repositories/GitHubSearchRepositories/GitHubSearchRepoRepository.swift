//
//  GitHubSearchRepoRepository.swift
//  GitHubSearchRepositories
//
//  Created by Greener Chen on 2022/10/23.
//

import Foundation

protocol Repository {
    var baseUrl: URL { get }
    var command: Command? { get set }
}

protocol GitHubSearchRepositoriesProtocol {
    func searchRepositories(withPlatform platform: Platform, inOrganization organization: String, completion: ((Result<[GithubRepository], Error>) -> Void)?)
}

public enum Platform: String {
    case android
    case ios
}

public class GitHubSearchRepoRepository: Repository, GitHubSearchRepositoriesProtocol {
    var baseUrl = URL(string: "https://api.github.com/search/repositories")!
    var command: Command?
    
    public func searchRepositories(withPlatform platform: Platform, inOrganization organization: String, completion: ((Result<[GithubRepository], Error>) -> Void)?) {
        command = GitHubSearchRepositoriesCommand(
            baseUrl: baseUrl,
            platform: platform,
            organization: organization,
            completion: completion
        )
        command?.execute()
    }
}
