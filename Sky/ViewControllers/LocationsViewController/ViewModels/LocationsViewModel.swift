//
//  LocationsViewModel.swift
//  Sky
//
//  Created by Ronan on 5/26/18.
//  Copyright © 2018 Mars. All rights reserved.
//

import UIKit
import CoreLocation

struct LocationsViewModel {
    let location: CLLocation?
    let locationText: String?
}

extension LocationsViewModel: LocationRepresentable {
    var labelText: String {
        if let locationText = locationText {
            return locationText
        }
        else if let location = location {
            return location.toString
        }
        
        return "Unknown position"
    }
}
