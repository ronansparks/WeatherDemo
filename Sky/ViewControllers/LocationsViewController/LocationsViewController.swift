//
//  LocationsViewController.swift
//  Sky
//
//  Created by Ronan on 5/26/18.
//  Copyright © 2018 Mars. All rights reserved.
//

import UIKit
import CoreLocation

protocol LocationsViewControllerDelegate {
    func controller(_ controller: LocationsViewController, didSelectLocation location: CLLocation)
}

class LocationsViewController: UITableViewController {
    
    @IBAction func unwindToLocationsViewController(segue: UIStoryboardSegue) {}
    private let segueAddLocationView = "SegueAddLocationView"
    
    var currentLocation: CLLocation?
    var delegate: LocationsViewControllerDelegate?
    var favorites = UserDefaults.loadLocations()
    
    private var hasFavorites: Bool {
        return favorites.count > 0
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension LocationsViewController {
    private enum Section: Int {
        case current
        case favorite
        
        var title: String {
            switch self {
            case .current:
                return "Current Location"
            case .favorite:
                return "Favorite Locations"
            }
        }
        
        static var count: Int {
            return Section.favorite.rawValue + 1
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return Section.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else {
            fatalError("Unexpected Section")
        }
        
        switch section {
        case .current:
            return 1
        case .favorite:
            return max(favorites.count, 1)
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let section = Section(rawValue: section) else {
            fatalError("Unexpected Section")
        }
        
        return section.title
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Section(rawValue: indexPath.section) else {
            fatalError("Unexpected Section")
        }
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: LocationTableViewCell.reuseIdentifier, for: indexPath)
            as? LocationTableViewCell else {
            fatalError("Unexpected table view cell")
        }
        
        var vm: LocationsViewModel?
        
        switch section {
        case .current:
            if let currentLocation = currentLocation {
                vm = LocationsViewModel(location: currentLocation, locationText: nil)
            }
            else {
                cell.label.text = "Current Location Unknown"
            }
        case .favorite:
            if favorites.count > 0 {
                let fav = favorites[indexPath.row]
                vm = LocationsViewModel(location: fav.location, locationText: fav.name)
            }
            else {
                cell.label.text = "No Favorites Yet..."
            }
        }
        
        if let vm = vm {
            cell.configure(with: vm)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        guard let section = Section(rawValue: indexPath.section) else { fatalError("Unexpected Section") }
        
        switch section {
        case .current:
            return false
        case .favorite:
            return true
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let location = favorites[indexPath.row]
        UserDefaults.removeLocation(location)
        
        favorites.remove(at: indexPath.row)
        tableView.reloadData()
    }
    
    // MARK: UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = Section(rawValue: indexPath.section) else {
            fatalError("Unexpected Section")
        }
        
        var location: CLLocation?
        
        switch section {
        case .current:
            if let currentLocation = currentLocation {
                location = currentLocation
            }
        case .favorite:
            if hasFavorites {
                location = favorites[indexPath.row].location
            }
        }
        
        if location != nil {
            delegate?.controller(self, didSelectLocation: location!)
            dismiss(animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case segueAddLocationView:
            let dest = segue.destination
            if let addLocationViewController = dest as? AddLocationViewController {
                addLocationViewController.delegate = self
            }
            else {
                fatalError("Unexpected destination view controllers")
            }
        default:
            break
        }
    }
}

extension LocationsViewController: AddLocationViewControllerDelegate {
    func controller(_ controller: AddLocationViewController, didAddLocation location: Location) {
        UserDefaults.addLocation(location)
        favorites.append(location)
        tableView.reloadData()
    }
}

