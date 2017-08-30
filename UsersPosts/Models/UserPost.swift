//
//  UserPost.swift
//  UsersPosts
//
//  Created by Marius Sincovici on 30/08/2017.
//  Copyright © 2017 Marius Sincovici. All rights reserved.
//

import Foundation

class UserPost {
    private struct Constants {
        static let userIdKey = "userId"
        static let postIdKey = "id"
        static let titleKey = "title"
        static let bodyKey = "body"
    }

    let userId: Int
    let postId: Int
    let title: String
    let body: String

    init?(json: [String: Any]) {

        guard let postId = json[Constants.postIdKey] as? Int,
            (postId > 0),
            let userId = json[Constants.userIdKey] as? Int,
            (userId > 0) else {

                assertionFailure()
                return nil
        }
        
        self.userId = userId
        self.postId = postId
        self.title = json[Constants.titleKey] as? String ?? ""
        self.body = json[Constants.bodyKey] as? String ?? ""
    }
}
