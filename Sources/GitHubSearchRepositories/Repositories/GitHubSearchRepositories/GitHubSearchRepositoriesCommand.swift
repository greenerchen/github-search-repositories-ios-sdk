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
    var completion: ((Result<[GithubRepositoryBrief], Error>) -> Void)? { get set }
    func parse(data: Data) throws -> [GithubRepositoryBrief]
}

public struct GitHubSearchRepositoriesCommand: GitHubSearchRepositoriesCommandProtocol {
    var baseUrl: URL
    var platform: Platform
    var organization: String
    var completion: ((Result<[GithubRepositoryBrief], Error>) -> Void)?
    var httpClient: HTTPClientProtocol = {
        HTTPClient()
    }()
    
    func execute() {
        let url = baseUrl.appending(queryItems: [
            URLQueryItem(name: "q", value: platform.rawValue),
            URLQueryItem(name: "org", value: organization)
        ])
        httpClient.get(url: url) { result in
            switch result {
            case .success(let data):
                do {
                    let models: [GithubRepositoryBrief] = try parse(data: data)
                    completion?(.success(models))
                } catch {
                    completion?(.failure(error))
                }
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
    
    func parse(data: Data) throws -> [GithubRepositoryBrief] {
        do {
            var models = [GithubRepositoryBrief]()
            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
               let items = json["items"] as? [AnyObject] {
                for item in items {
                    let name = item["name"] as? String
                    let isPrivate = item["private"] as? Bool
                    let repoDescription = item["description"] as? String
                    let language = item["language"] as? String
                    let model = GithubRepositoryBrief(
                        name: name ?? "",
                        isPrivate: isPrivate ?? false,
                        repoDescription: repoDescription ?? "",
                        language: language ?? ""
                    )
                    debugPrint(model.description)
                    models.append(model)
                }
            }
            return models
        } catch {
            throw error
        }
    }
}
