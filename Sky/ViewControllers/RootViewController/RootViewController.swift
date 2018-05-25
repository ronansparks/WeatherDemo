//
//  ViewController.swift
//  Sky
//
//  Created by Ronan on 5/25/18.
//  Copyright © 2018 Mars. All rights reserved.
//

import UIKit
import CoreLocation

class RootViewController: UIViewController {
    
    var currentWeatherViewController: CurrentWeatherViewController!
    private let segueCurrentWeather = "SegueCurrentWeather"
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case segueCurrentWeather:
            guard let destination = segue.destination as? CurrentWeatherViewController else {
                fatalError("Invalid destination view controller.")
            }
            
            destination.delegate = self
            destination.viewModel = CurrentWeatherViewModel()
            currentWeatherViewController = destination
        default:
            break
        }
    }

    private var currentLocation: CLLocation? {
        didSet {
            // Fetch the city name
            fetchCity()
            
            // Fetch the weather data
            fetchWeather()
        }
    }
    
    private func fetchWeather() {
        guard let currentLocation = currentLocation else { return }
        
        let lat = currentLocation.coordinate.latitude
        let lon = currentLocation.coordinate.longitude
        
        WeatherDataManager.shared.weatherDataAt(latitude: lat, longitude: lon) { (response, error) in
            if let error = error {
                dump(error)
            }
            else if let response = response {
                // Notify currentWeatherViewController
                self.currentWeatherViewController.viewModel?.weather = response
            }
        }
    }
    
    private func fetchCity() {
        guard let currentLocation = currentLocation else { return }
        
        CLGeocoder().reverseGeocodeLocation(currentLocation) { (placemarks, error) in
            if let error = error {
                dump(error)
            }
            else if let city = placemarks?.first?.locality {
                // Notify CurrentWeatherViewController
                let l = Location(
                    name: city,
                    latitude: currentLocation.coordinate.latitude,
                    longitude: currentLocation.coordinate.longitude)
                self.currentWeatherViewController.viewModel?.location = l
            }
        }
    }
    
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.distanceFilter = 1000
        manager.desiredAccuracy = 1000
        
        return manager
    }()
    
    private func requestLocation() {
        locationManager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
        else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupActiveNotification()
    }

    @objc func applicationDidBecomeActive(notification: Notification) {
        
        // Request user's location.
        requestLocation()
    }
    
    private func setupActiveNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.applicationDidBecomeActive(notification:)),
            name: NSNotification.Name.UIApplicationDidBecomeActive,
            object: nil)
    }
}

extension RootViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            currentLocation = location
            manager.delegate = nil
            
            manager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            manager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        dump(error)
    }
}

extension RootViewController: CurrentWeatherControllerDelegate {
    func locationButtonPressed(controller: CurrentWeatherViewController) {
        print("Open locations")
    }
    
    func settingsButtonPressed(controlelr: CurrentWeatherViewController) {
        print("Open settings")
    }
    
    
}
