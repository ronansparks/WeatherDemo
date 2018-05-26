//
//  SettingsContent.swift
//  Sky
//
//  Created by Ronan on 5/26/18.
//  Copyright © 2018 Mars. All rights reserved.
//

import UIKit

protocol SettingsRepresentable {
    var labelText: String { get }
    var accessory: UITableViewCellAccessoryType { get }
}
