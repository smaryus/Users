//
//  Task.swift
//  UsersPosts
//
//  Created by Marius Sincovici on 30/08/2017.
//  Copyright © 2017 Marius Sincovici. All rights reserved.
//

import Foundation

/// Defines the protocol that each network task must implement
protocol Task {
    /// Returns true while the task is running and downloads data, otherwise false
    var isRunning: Bool { get }

    /// If task was canceled this will be true
    var canceled: Bool { get }

    /// The url from where data is downloaded
    var url: URL { get }

    /// Initializer with URL
    ///
    /// - Parameter url: url assigned to the task
    init(url: URL)

    /// Starts the task execution
    ///
    /// - Parameter completion: closure called after task finished
    ///             results - is downloaded parsed results or nil for error
    ///             error - result error or nil if nothing failed
    func start(completion: @escaping (_ results: Any?, _ error: Error?)->Void)

    /// Cancel the running task
    func cancel()
}

