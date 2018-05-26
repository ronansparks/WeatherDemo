//
//  SettingsDateViewModel.swift
//  Sky
//
//  Created by Ronan on 5/26/18.
//  Copyright © 2018 Mars. All rights reserved.
//

import UIKit

struct SettingsDateViewModel {
    let dateMode: DateMode
    
    var labelText: String {
        return dateMode == .text ? "Fri, 01 December" : "F, 12/01"
    }
    
    var accessory: UITableViewCellAccessoryType {
        if UserDefaults.dateMode() == dateMode {
            return .checkmark
        }
        else {
            return .none
        }
    }
}

extension SettingsDateViewModel: SettingsRepresentable {}
