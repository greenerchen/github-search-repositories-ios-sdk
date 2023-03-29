//
//  GithubRepository.swift
//  GitHubSearchRepositories
//
//  Created by Greener Chen on 2022/10/23.
//

import Foundation

public struct GithubRepository: Codable {
    let name: String
    let isPrivate: Bool
    let repoDescription: String
    let language: String
}

extension GithubRepository: CustomStringConvertible {
    public var description: String {
        """
        GithubRepository
            name: \(name)
            isPrivate: \(isPrivate)
            repoDescription: \(repoDescription)
            language: \(language)
        
        """
    }
}
