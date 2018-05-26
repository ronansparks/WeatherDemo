//
//  SettingsTableViewCell.swift
//  Sky
//
//  Created by Ronan on 5/26/18.
//  Copyright © 2018 Mars. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

    static let reuseIdentifier = "SettingsTableViewCell"
    @IBOutlet var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    func configure(with vm: SettingsRepresentable) {
        label.text = vm.labelText
        accessoryType = vm.accessory
    }
}
