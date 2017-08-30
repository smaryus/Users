//
//  UserInfo.swift
//  UsersPosts
//
//  Created by Marius Sincovici on 30/08/2017.
//  Copyright © 2017 Marius Sincovici. All rights reserved.
//

import Foundation

final class UserInfo {
    private struct Constants {
        static let idKey = "id"
        static let nameKey = "name"
        static let userNameKey = "username"
        static let emailKey = "email"
        static let addressKey = "address"
        static let streetKey = "street"
        static let suiteKey = "suite"
        static let cityKey = "city"
        static let zipCodeKey = "zipcode"
        static let geoKey = "geo"
        static let latKey = "lat"
        static let lngKey = "lng"
        static let phoneKey = "phone"
        static let websiteKey = "website"
        static let companyKey = "company"
        static let companyNameKey = "name"
        static let catchPhraseKey = "catchPhrase"
        static let bsKey = "bs"
    }
    
    struct Address {
        let city: String
        let zipCode: String
        let street: String
        let suite: String
        let lat: Double
        let lon: Double
    }

    struct Company {
        let name: String
        let catchPhrase: String
        let bs: String
    }

    let id: Int
    let name: String
    let userName: String
    let email: String
    let address: Address?
    let phone: String
    let website: String
    let company: Company?

    init?(jsonObject: [String: Any]) {

        guard let id = jsonObject[Constants.idKey] as? Int,
            (id > 0) else {
            assertionFailure()
            return nil
        }

        self.id = id
        self.name = jsonObject[Constants.nameKey] as? String ?? ""
        self.userName = jsonObject[Constants.userNameKey] as? String ?? ""
        self.email = jsonObject[Constants.emailKey] as? String ?? ""

        // address

        if let address = jsonObject[Constants.addressKey] as? [String: Any] {
            let city = address[Constants.cityKey] as? String ?? ""
            let zipCode = address[Constants.zipCodeKey] as? String ?? ""
            let street = address[Constants.streetKey] as? String ?? ""
            let suite = address[Constants.suiteKey] as? String ?? ""
            let lat: Double
            let lon: Double

            if let geo = address[Constants.geoKey] as? [String: Double] {
                lat = geo[Constants.latKey] ?? 0
                lon = geo[Constants.lngKey] ?? 0
            } else {
                lat = 0
                lon = 0
            }

            self.address = Address(city: city, zipCode: zipCode,
                                   street: street, suite: suite,
                                   lat: lat, lon: lon)
        } else {
            self.address = nil
        }

        self.phone = jsonObject[Constants.phoneKey] as? String ?? ""
        self.website = jsonObject[Constants.websiteKey] as? String ?? ""

        if let company = jsonObject[Constants.companyKey] as? [String: String] {
            let companyName = company[Constants.companyNameKey] ?? ""
            let catchPhrase = company[Constants.catchPhraseKey] ?? ""
            let bs = company[Constants.bsKey] ?? ""

            self.company = Company(name: companyName,
                                   catchPhrase: catchPhrase, bs: bs)
        } else {
            self.company = nil
        }
    }
}
