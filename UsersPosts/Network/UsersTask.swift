//
//  UsersTask.swift
//  UsersPosts
//
//  Created by Marius Sincovici on 30/08/2017.
//  Copyright © 2017 Marius Sincovici. All rights reserved.
//

import Foundation

class UsersTask: BaseTask {

    // Parses the data received and retuns an array of [UserInfo]
    override func parseData(data: Data) -> [Any]? {
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

