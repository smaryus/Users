//
//  BaseTask.swift
//  UsersPosts
//
//  Created by Marius Sincovici on 30/08/2017.
//  Copyright © 2017 Marius Sincovici. All rights reserved.
//

import Foundation


class BaseTask: Task {
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
        self.task?.cancel()
        self.task = nil
        self.canceled = true
    }

    /// This must be override by subclasses
    internal func parseData(data: Data) -> [Any]? {
        fatalError()
    }
}
