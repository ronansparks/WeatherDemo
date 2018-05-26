//
//  CurrentWeatherViewModel.swift
//  Sky
//
//  Created by Ronan on 5/25/18.
//  Copyright © 2018 Mars. All rights reserved.
//

import UIKit

struct CurrentWeatherViewModel {
    
    var weather: WeatherData
    
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
        return String(format: "%.1f %%", weather.currently.humidity * 100)
    }
    
    var summary: String {
        return weather.currently.summary
    }
    
    var date: String {
        let formatter = DateFormatter()
        formatter.dateFormat = UserDefaults.dateMode().format
        
        return formatter.string(from: weather.currently.time)
    }
    
    static let empty = CurrentWeatherViewModel(weather: WeatherData.empty)
    
    var isEmpty: Bool {
        return self.weather == WeatherData.empty
    }
    
    static let invalid = CurrentWeatherViewModel(weather: .invalid)
    
    var isInvalid: Bool {
        return self.weather == WeatherData.invalid
    }
}
