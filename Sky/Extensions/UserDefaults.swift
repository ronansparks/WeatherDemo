//
//  UserDefaults.swift
//  Sky
//
//  Created by Ronan on 5/26/18.
//  Copyright © 2018 Mars. All rights reserved.
//

import Foundation

enum DateMode: Int {
    case text
    case digit
    
    var format: String {
        return self == .text ? "E, dd MMMM" : "EEEE, MM/dd"
    }
}

enum TemperatureMode: Int {
    case celcius
    case fahrenheit
}

enum UsesrDefaultsKeys {
    static let dateMode = "dateMode"
    static let temperatureMode = "temperatureMode"
}

extension UserDefaults {
    static func dateMode() -> DateMode {
        let value = UserDefaults.standard.integer(forKey: UsesrDefaultsKeys.dateMode)
        
        return DateMode(rawValue: value) ?? DateMode.text
    }
    
    static func setDateMode(to value: DateMode) {
        UserDefaults.standard.set(value.rawValue, forKey: UsesrDefaultsKeys.dateMode)
    }
    
    
    static func temperatureMode() -> TemperatureMode {
        let value = UserDefaults.standard.integer(forKey: UsesrDefaultsKeys.temperatureMode)
        
        return TemperatureMode(rawValue: value) ?? TemperatureMode.celcius
    }
    
    static func setTemperatureMode(to value: TemperatureMode) {
        UserDefaults.standard.set(value.rawValue, forKey: UsesrDefaultsKeys.temperatureMode)
    }
}
