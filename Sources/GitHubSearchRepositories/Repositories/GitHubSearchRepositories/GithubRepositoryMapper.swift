//
//  File.swift
//  
//
//  Created by Greener Chen on 2023/3/29.
//

import Foundation

struct GithubRepositoryMapper {
    struct Root: Decodable {
        let totalCount: Int
        let incompleteResults: Bool
        let items: [Item]
        
        enum CodingKeys: String, CodingKey {
            case totalCount = "total_count"
            case incompleteResults = "incomplete_results"
            case items
        }
    }
    
    struct Item: Decodable {
        let name: String
        let isPrivate: Bool
        let repoDescription: String?
        let language: String?
        
        enum CodingKeys: String, CodingKey {
            case name
            case isPrivate = "private"
            case repoDescription = "description"
            case language
        }
        
        var item: GithubRepository {
            GithubRepository(
                name: name,
                isPrivate: isPrivate,
                repoDescription: repoDescription ?? "",
                language: language ?? "")
        }
        
        init(from decoder: Decoder) throws {
            let container: KeyedDecodingContainer<GithubRepositoryMapper.Item.CodingKeys> = try decoder.container(keyedBy: GithubRepositoryMapper.Item.CodingKeys.self)
            self.name = try container.decode(String.self, forKey: GithubRepositoryMapper.Item.CodingKeys.name)
            self.isPrivate = try container.decode(Bool.self, forKey: GithubRepositoryMapper.Item.CodingKeys.isPrivate)
            self.repoDescription = try container.decodeIfPresent(String.self, forKey: GithubRepositoryMapper.Item.CodingKeys.repoDescription)
            self.language = try container.decodeIfPresent(String.self, forKey: GithubRepositoryMapper.Item.CodingKeys.language)
        }
    }
    
    func map(data: Data, decoder: JSONDecoder = .init()) throws -> [GithubRepository] {
        try decoder.decode(Root.self, from: data).items.map { $0.item }
    }
}
