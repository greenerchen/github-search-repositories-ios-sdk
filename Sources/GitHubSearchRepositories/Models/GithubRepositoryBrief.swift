//
//  GithubRepositoryBrief.swift
//  GitHubSearchRepositories
//
//  Created by Greener Chen on 2022/10/23.
//

import Foundation

public struct GithubRepositoryBrief: Codable {
    let name: String
    let isPrivate: Bool
    let repoDescription: String
    let language: String
}

extension GithubRepositoryBrief: CustomStringConvertible {
    public var description: String {
        """
        GithubRepositoryBrief
            name: \(name)
            isPrivate: \(isPrivate)
            repoDescription: \(repoDescription)
            language: \(language)
        
        """
    }
}
