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
    
    var city: String {
        return location.name
    }
    
    static let empty = CurrentLocationViewModel(location: Location.empty)
    
    var isEmpty: Bool {
        return self.location == Location.empty
    }
    
    static let invalid = CurrentLocationViewModel(location: .invalid)
    
    var isInvalid: Bool {
        return self.location == Location.invalid
    }
}
