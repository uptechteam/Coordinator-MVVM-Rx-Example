//
//  Repository.swift
//  Coordinators-MVVM-Rx Example
//
//  Created by Arthur Myronenko on 6/29/17.
//  Copyright © 2017 Arthur Myronenko. All rights reserved.
//

import Foundation

struct Repository: Codable {
    let fullName: String
    let description: String
    let starsCount: Int
    let url: String

    private enum CodingKeys: String, CodingKey {
        case fullName = "full_name"
        case description
        case starsCount = "stargazers_count"
        case url = "html_url"
    }
}
