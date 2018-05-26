//
//  ViewController.swift
//  Sky
//
//  Created by Ronan on 5/25/18.
//  Copyright © 2018 Mars. All rights reserved.
//

import UIKit
import CoreLocation
import RxSwift
import RxCocoa

class RootViewController: UIViewController {
    
    var currentWeatherViewController: CurrentWeatherViewController!
    var weekWeatherViewController: WeekWeatherViewController!
    
    private let segueCurrentWeather = "SegueCurrentWeather"
    private let segueWeekWeather = "SegueWeekWeather"
    private let segueSettings  = "SegueSettings"
    private let segueLocations = "SegueLocations"
    private var bag = DisposeBag()
    
    @IBAction func unwindToRootViewController(segue: UIStoryboardSegue) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case segueCurrentWeather:
            
            guard let destination = segue.destination as? CurrentWeatherViewController else {
                fatalError("Invalid destination view controller.")
            }
            
            destination.delegate = self
            currentWeatherViewController = destination
        case segueWeekWeather:
            
            guard let destination = segue.destination as? WeekWeatherViewController else {
                fatalError("Invalid destination view controller.")
            }
            
            weekWeatherViewController = destination
        case segueSettings:
            
            guard let navigationController =
                segue.destination as? UINavigationController else { fatalError("Invalid destination view controller") }
            
            guard let destination =
                navigationController.topViewController as?
                SettingsTableViewController else { fatalError("Invalid destination view controller") }
            
            destination.delegate = self
        case segueLocations:
            
            guard let navigationController = segue.destination as? UINavigationController else {
                fatalError("Invalid destination view controller")
            }
            
            guard let destination = navigationController.topViewController as? LocationsViewController else {
                fatalError("Invalid destination view controller")
            }
            
            destination.delegate = self
            destination.currentLocation = currentLocation
        default:
            break
        }
    }

    private var currentLocation: CLLocation? {
        didSet {
            fetchCity()
            fetchWeather()
        }
    }
    
    private func fetchWeather() {
        guard let currentLocation = currentLocation else { return }
        
        let lat = currentLocation.coordinate.latitude
        let lon = currentLocation.coordinate.longitude
        
        let weather = WeatherDataManager.shared
            .weatherDataAt(latitude: lat, longitude: lon)
            .share(replay: 1, scope: .whileConnected)
            .observeOn(MainScheduler.instance)
        
        weather.map { CurrentWeatherViewModel(weather: $0) }
            .bind(to: self.currentWeatherViewController.weatherVM)
            .disposed(by: bag)
        
        weather.map { WeekWeatherViewModel(weatherData: $0.daily.data) }
            .subscribe(onNext: {
                self.weekWeatherViewController.viewModel = $0
            })
            .disposed(by: bag)
    }
    
    private func fetchCity() {
        guard let currentLocation = currentLocation else { return }
        
        CLGeocoder().reverseGeocodeLocation(currentLocation) { (placemarks, error) in
            if let error = error {
                dump(error)
            }
            else if let city = placemarks?.first?.locality {
                // Notify CurrentWeatherViewController
                let location = Location(
                    name: city,
                    latitude: currentLocation.coordinate.latitude,
                    longitude: currentLocation.coordinate.longitude)
                
                self.currentWeatherViewController.locationVM.accept(CurrentLocationViewModel(location: location))
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
        performSegue(withIdentifier: segueLocations, sender: self)
    }
    
    func settingsButtonPressed(controlelr: CurrentWeatherViewController) {
        performSegue(withIdentifier: segueSettings, sender: self)
    }
}

extension RootViewController: SettingsViewControllerDelegate {
    private func reloadUI() {
        currentWeatherViewController.updateView()
        weekWeatherViewController.updateView()
    }
    func controllerDidChangeTimeMode(controller: SettingsTableViewController) {
        reloadUI()
    }
    
    func controllerDidChangeTemperatureMode(controller: SettingsTableViewController) {
        reloadUI()
    }
}

extension RootViewController: LocationsViewControllerDelegate {
    func controller(_ controller: LocationsViewController, didSelectLocation location: CLLocation) {
        currentLocation = location
    }
    
    
}
