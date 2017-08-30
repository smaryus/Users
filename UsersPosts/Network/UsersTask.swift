//
//  UsersTask.swift
//  UsersPosts
//
//  Created by Marius Sincovici on 30/08/2017.
//  Copyright © 2017 Marius Sincovici. All rights reserved.
//

import Foundation

class UsersTask: Task {
    private(set) var isRunning: Bool = false
    private(set) var canceled: Bool = false
    let url: URL

    var task: URLSessionTask? = nil

    required init(url: URL) {
        self.url = url
    }

    func start(completion: @escaping (Any?, Error?) -> Void) {
        if self.task != nil {
            return
        }

        self.task = URLSession.shared.dataTask(with: self.url) { [weak self] (data, urlResponse, error) in
            guard let sSelf = self else { return }

            sSelf.isRunning = false

            if (sSelf.canceled == true) {
                return
            }

            guard let data = data, (error == nil) else {
                completion(nil, error)
                return
            }

            let results = sSelf.parseData(data: data)

            completion(results, error)
        }
        
        self.isRunning = true
        self.task?.resume()
    }

    func cancel() {

    }

    // MARK - private methods
    private func parseData(data: Data) -> [UserInfo]? {
        // try to parse the response
        guard let jsonObject = (try? JSONSerialization.jsonObject(with: data)) as? [Any] else {
                return nil
        }

        var results: [UserInfo] = []
        results.reserveCapacity(jsonObject.count)

        for object in jsonObject {
            guard let object = object as? [String: Any] else { continue }

            if let matchData = UserInfo(jsonObject: object) {
                results.append(matchData)
            }
        }
        
        return results
    }
}

