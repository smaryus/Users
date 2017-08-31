//
//  UsersDataSource.swift
//  UsersPosts
//
//  Created by Marius Sincovici on 30/08/2017.
//  Copyright © 2017 Marius Sincovici. All rights reserved.
//

import Foundation


class UsersDataSource {

    /// Users list
    private(set) var results: [UserInfo] = []

    /// Error information related to the last request
    private(set) var error: Error? = nil

    /// Url to the users request
    private let usersUrl: URL

    /// Current running task
    private var task: Task? = nil

    /// Running task class
    private let usersTaskClass: Task.Type

    /// Constructs Users data source
    ///
    /// - Parameters:
    ///   - serverUrl: server url from where it will download the users list
    ///   - usersTaskClass: Task class used to download
    init(serverUrl: URL, usersTaskClass: Task.Type = UsersTask.self) {
        self.usersUrl = serverUrl
        self.usersTaskClass = usersTaskClass
    }

    /// Fetch the users list
    ///
    /// - Parameter completion: Called after fetch finished. The completion bloc
    ///                         is always called on main thread
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
