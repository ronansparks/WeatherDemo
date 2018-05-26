//
//  AddLocationViewModel.swift
//  Sky
//
//  Created by Ronan on 5/26/18.
//  Copyright © 2018 Mars. All rights reserved.
//

import Foundation
import CoreLocation

class AddLocationViewModel {
    
    var queryText: String = "" {
        didSet {
            geocode(address: queryText)
        }
    }
    
    private func geocode(address: String?) {
        guard let address = address, !address.isEmpty else {
            locations = []
            
            return
        }
        
        isQuerying = true
        
        geocoder.geocodeAddressString(address) {
            [weak self] (placemarks, error) in
            DispatchQueue.main.async {
                self?.processResponse(with: placemarks, error: error)
            }
        }
    }
    
    private func processResponse(with placemarks: [CLPlacemark]?, error: Error?) {
        isQuerying = false
        var locs: [Location] = []
        
        if let error = error {
            print("Cannot handle Geocode Address! \(error)")
        }
        else if let results = placemarks {
            locs = results.compactMap {
                guard let name = $0.name else { return nil }
                guard let locaiton = $0.location else { return nil }
                
                return Location(name: name, latitude: locaiton.coordinate.latitude, longitude: locaiton.coordinate.longitude)
            }
            
            self.locations = locs
        }
    }
    
    private var isQuerying = false {
        didSet {
            queryingStatusDidChange?(isQuerying)
        }
    }
    
    private var locations: [Location] = [] {
        didSet {
            locationsDidChange?(locations)
        }
    }
    
    private lazy var geocoder = CLGeocoder()
    
    var queryingStatusDidChange: ((Bool) -> Void)?
    var locationsDidChange: (([Location]) -> Void)?
    
    var numberOfLocations: Int { return locations.count }
    var hasLocationResult: Bool {
        return numberOfLocations > 0
    }
    
    func location(at index: Int) -> Location? {
        guard index < numberOfLocations else {
            return nil
        }
        
        return locations[index]
    }
    
    func locationViewModel(at index: Int) -> LocationRepresentable? {
        guard let location = location(at: index) else { return nil }
        
        return LocationsViewModel(location: location.location, locationText: location.name)
    }
}
