//
//  Repository.swift
//  GitHubRepository
//
//  Created by hana on 2022/09/02.
//

import Foundation

//https://api.github.com/orgs/apple/repos
struct Repository: Decodable {
    let id: Int
    let name: String
    let description: String
    let stargazersCount: Int    //즐겨찾기 수
    let language: String
    
    enum CodingKeys: String, CodingKey{
        case id, name, description, language
        case stargazersCount = "stargazers_count"
    }
}
