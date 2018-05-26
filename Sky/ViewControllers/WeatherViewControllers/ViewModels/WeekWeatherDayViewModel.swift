//
//  WeekWeatherDayViewModel.swift
//  Sky
//
//  Created by Ronan on 5/26/18.
//  Copyright © 2018 Mars. All rights reserved.
//


import UIKit

struct WeekWeatherDayViewModel {
    let weatherData: ForecastData
    
    private let dateFormatter = DateFormatter()
    
    var week: String {
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: weatherData.time)
    }
    
    var date: String {
        dateFormatter.dateFormat = "MMMMM d"
        return dateFormatter.string(from: weatherData.time)
    }
    
    var temperature: String {
        let min = format(temperature: weatherData.temperatureLow)
        let max = format(temperature: weatherData.temperatureHigh)
        
        return "\(min) - \(max)"
    }
    
    var weatherIcon: UIImage? {
        return UIImage.weatherIcon(of: weatherData.icon)
    }
    
    var humidity: String {
        return String(format: "%.f %%", weatherData.humidity * 100)
    }
    
    // Helpers
    private func format(temperature: Double) -> String {
        switch UserDefaults.temperatureMode() {
        case .celcius:
            return String(format: "%.0f ℃", temperature.toCelcius())
        case .fahrenheit:
            return String(format: "%.0f °F", temperature)
        }
    }
}

extension WeekWeatherDayViewModel: WeekWeatherDayRepresentable {}
