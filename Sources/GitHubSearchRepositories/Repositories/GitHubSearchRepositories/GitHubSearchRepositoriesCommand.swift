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
    func parse(data: Data) throws -> [GithubRepository]
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
                    let models: [GithubRepository] = try parse(data: data)
                    completion?(.success(models))
                } catch {
                    completion?(.failure(error))
                }
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
    
    func parse(data: Data) throws -> [GithubRepository] {
        do {
            var models = [GithubRepository]()
            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
               let items = json["items"] as? [AnyObject] {
                for item in items {
                    let name = item["name"] as? String
                    let isPrivate = item["private"] as? Bool
                    let repoDescription = item["description"] as? String
                    let language = item["language"] as? String
                    let model = GithubRepository(
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
