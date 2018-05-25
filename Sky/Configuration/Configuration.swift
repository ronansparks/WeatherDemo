//
//  Configuration.swift
//  Sky
//
//  Created by Ronan on 5/24/18.
//  Copyright © 2018 Mars. All rights reserved.
//

import Foundation

struct API {
    static let key = "8db2e20257620e2ffe32f1b5497c5a3c"
    static let baseURL = URL(string: "https://api.darksky.net/forecast/")!
    static let authenticateURL = baseURL.appendingPathComponent(key)
}
