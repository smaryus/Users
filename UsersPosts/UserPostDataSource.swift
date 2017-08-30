//
//  UserPostDataSource.swift
//  UsersPosts
//
//  Created by Marius Sincovici on 30/08/2017.
//  Copyright © 2017 Marius Sincovici. All rights reserved.
//

import Foundation

class UserPostDataSource {

    private(set) var results: [UserPost] = []
    private(set) var error: Error? = nil

    private let baseUrlString: String

    private var task: Task? = nil
    private let userPostsTaskClass: Task.Type

    init(baseUrlString: String, userPostsTaskClass: Task.Type = UserPostsTask.self) {
        self.baseUrlString = baseUrlString
        self.userPostsTaskClass = userPostsTaskClass
    }

    @discardableResult
    func fetchPosts(for user: UserInfo,
                    completion: ((_ results: [UserPost]?, _ error: Error?) -> Void)?) -> Bool {
        self.task?.cancel()
        self.task = nil
        self.results.removeAll()
        self.error = nil

        guard let url = self.generateUrl(user: user) else { return false }

        self.task = self.userPostsTaskClass.init(url: url)

        self.task?.start { [weak self] (results, error) in
            guard let sSelf = self else { return }

            DispatchQueue.main.async {
                sSelf.results = results as? [UserPost] ?? []
                sSelf.error = error

                completion?(sSelf.results, sSelf.error)
            }
        }

        return true
    }

    private func generateUrl(user: UserInfo) -> URL? {
        let url = URL(string: "\(self.baseUrlString)?userId=\(user.id)")

        return url
    }
}
