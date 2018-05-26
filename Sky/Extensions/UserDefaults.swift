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
    static let locations = "locations"
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
    
    
    // Locations
    
    static func saveLocations(_ locations: [Location]) {
        let dictionaries: [[String: Any]] = locations.map { $0.toDictionary }
        
        UserDefaults.standard.set(dictionaries, forKey: UsesrDefaultsKeys.locations)
    }
    
    static func loadLocations() -> [Location] {
        let data = UserDefaults.standard.array(forKey: UsesrDefaultsKeys.locations)
        guard let dictionaries = data as? [[String: Any]] else { return [] }
        
        return dictionaries.compactMap {
            return Location(from: $0)
        }
    }
    
    static func addLocation(_ location: Location) {
        var locations = loadLocations()
        locations.append(location)
        
        saveLocations(locations)
    }
    
    static func removeLocation(_ location: Location) {
        var locations = loadLocations()
        
        guard let index = locations.index(of: location) else { return }
        
        locations.remove(at: index)
        
        saveLocations(locations)
    }
}
