//
//  SettingsTemperatureViewModel.swift
//  Sky
//
//  Created by Ronan on 5/26/18.
//  Copyright © 2018 Mars. All rights reserved.
//

import UIKit

struct SettingsTemperatureViewModel {
    let temperatureMode: TemperatureMode
    
    var labelText: String {
        return temperatureMode == .celcius ? "Celcius" : "Fahrenheit"
    }
    
    var accessory: UITableViewCellAccessoryType {
        if UserDefaults.temperatureMode() == temperatureMode {
            return .checkmark
        }
        else {
            return .none
        }
    }
}

extension SettingsTemperatureViewModel: SettingsRepresentable {}
