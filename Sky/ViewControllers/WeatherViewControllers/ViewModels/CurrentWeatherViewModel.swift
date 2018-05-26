//
//  CurrentWeatherViewModel.swift
//  Sky
//
//  Created by Ronan on 5/25/18.
//  Copyright © 2018 Mars. All rights reserved.
//

import UIKit

struct CurrentWeatherViewModel {
    
    var isLocationReady = false
    var isWeatherReady = false
    
    var isUpdateReady: Bool {
        return isLocationReady && isWeatherReady
    }
    
    var location: Location! {
        didSet {
            if location != nil {
                isLocationReady = true
            }
            else {
                isLocationReady = false
            }
        }
    }
    
    var weather: WeatherData! {
        didSet {
            if weather != nil {
                isWeatherReady = true
            }
            else {
                isWeatherReady = false
            }
        }
    }
    
    var city: String {
        return location.name
    }
    
    var weatherIcon: UIImage {
        return UIImage.weatherIcon(of: weather.currently.icon)!
    }
    
    var temperature: String {
        let value = weather.currently.temperature
        
        switch UserDefaults.temperatureMode() {
        case .fahrenheit:
            return String(format: "%.1f °F", value)
        case .celcius:
            return String(format: "%.1f ℃", value.toCelcius())
        }
        
    }
    
    var humidity: String {
        return String(format: "%.1f %%", weather.currently.humidity)
    }
    
    var summary: String {
        return weather.currently.summary
    }
    
    var date: String {
        let formatter = DateFormatter()
        formatter.dateFormat = UserDefaults.dateMode().format
        
        return formatter.string(from: weather.currently.time)
    }
}
