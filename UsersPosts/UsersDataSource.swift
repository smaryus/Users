//
//  UsersDataSource.swift
//  UsersPosts
//
//  Created by Marius Sincovici on 30/08/2017.
//  Copyright © 2017 Marius Sincovici. All rights reserved.
//

import Foundation


class UsersDataSource {

    private(set) var results: [UserInfo] = []
    private(set) var error: Error? = nil

    private let usersUrl: URL

    private var task: Task? = nil
    private let usersTaskClass: Task.Type

    init(serverUrl: URL, usersTaskClass: Task.Type = UsersTask.self) {
        self.usersUrl = serverUrl
        self.usersTaskClass = usersTaskClass
    }

    func fetchUsers(completion: ((_ results: [UserInfo]?, _ error: Error?) -> Void)?) {
        self.task?.cancel()
        self.task = nil
        self.results.removeAll()
        self.error = nil

        self.task = self.usersTaskClass.init(url: self.usersUrl)
        self.task?.start { [weak self] (results, error) in
            guard let sSelf = self else { return }

            DispatchQueue.main.async {
                sSelf.results = results as? [UserInfo] ?? []
                sSelf.error = error

                completion?(sSelf.results, sSelf.error)
            }
        }
    }
}
