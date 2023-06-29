//
//  Tweet.swift
//  Twitter
//
//  Created by Ahmet on 29.06.2023.
//

import Foundation

struct Tweet: Codable, Identifiable {
    var id = UUID().uuidString
    let author: TwitterUser
    let authID: String
    let tweetContent: String
    var likesCount: Int
    var likers: [String]
    let isReply: Bool
    let parentReference: String?
}
