//
//  CurrentLocationViewModel.swift
//  Sky
//
//  Created by Ronan on 5/26/18.
//  Copyright © 2018 Mars. All rights reserved.
//

import Foundation

struct CurrentLocationViewModel {
    var location: Location
    static let empty = CurrentLocationViewModel(location: Location.empty)
    
    var city: String {
        return location.name
    }
    
    var isEmpty: Bool {
        return self.location == Location.empty
    }
}
