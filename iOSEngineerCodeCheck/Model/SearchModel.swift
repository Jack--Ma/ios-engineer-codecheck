//
//  SearchRepoModel.swift
//  iOSEngineerCodeCheck
//
//  Created by jackma on 2023/5/28.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import Foundation

class SearchListModel: Decodable {
    var repoModels: [SearchRepoModel] = []
    
    enum CodingKeys: String, CodingKey {
        case repoModels = "items"
    }
    
    required init(from decoder: Decoder) throws {
        let items = try decoder.container(keyedBy: CodingKeys.self)
        repoModels = try items.decode([SearchRepoModel].self, forKey: .repoModels)
    }
}

class SearchRepoModel: Decodable {
    var fullName: String? = ""
    var language: String? = ""
    var starsCount: Int = 0
    var watchersCount: Int = 0
    var forksCount: Int = 0
    var openIssuesCount: Int = 0
    var owner: SearchRepoOwnerModel?
    
    enum CodingKeys: String, CodingKey {
        case fullName = "full_name"
        case language = "language"
        case starsCount = "stargazers_count"
        case watchersCount = "watchers_count"
        case forksCount = "forks_count"
        case openIssuesCount = "open_issues_count"
        case owner = "owner"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        fullName = try values.decode(String.self, forKey: .fullName)
        // In case language value is null
        if let language = try? values.decode(String.self, forKey: .language) {
            self.language = language
        }
        starsCount = try values.decode(Int.self, forKey: .starsCount)
        watchersCount = try values.decode(Int.self, forKey: .watchersCount)
        forksCount = try values.decode(Int.self, forKey: .forksCount)
        openIssuesCount = try values.decode(Int.self, forKey: .openIssuesCount)
        owner = try values.decode(SearchRepoOwnerModel.self, forKey: .owner)
    }
}

class SearchRepoOwnerModel: Decodable {
    var avatarURLString: String? = ""
    
    enum CodingKeys: String, CodingKey {
        case avatarURLString = "avatar_url"
    }
}
