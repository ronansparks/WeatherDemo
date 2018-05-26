//
//  WeekWeatherViewModel.swift
//  Sky
//
//  Created by Ronan on 5/25/18.
//  Copyright © 2018 Mars. All rights reserved.
//

import UIKit

struct WeekWeatherViewModel {
    let weatherData: [ForecastData]
    
    private let dateFormatter = DateFormatter()
    
    func week(for index: Int) -> String {
        dateFormatter.dateFormat = "EEEE"
        
        return dateFormatter.string(from: weatherData[index].time)
    }
    
    func date(for index: Int) -> String {
        dateFormatter.dateFormat = "MMMM d"
        return dateFormatter.string(from: weatherData[index].time)
    }
    
    func temperature(for index: Int) -> String {
//        let min = String(format: "%.0f ℃", weatherData[index].temperatureLow.toCelcius())
//        let max = String(format: "%.0f ℃", weatherData[index].temperatureHigh.toCelcius())
        let min = format(temperature: weatherData[index].temperatureLow)
        let max = format(temperature: weatherData[index].temperatureHigh)
        
        return "\(min) - \(max)"
    }
    
    func weatherIcon(for index: Int) -> UIImage? {
        return UIImage.weatherIcon(of: weatherData[index].icon)
    }
    
    func humidity(for index: Int) -> String {
        return String(format: "%.0f %%", weatherData[index].humidity)
    }
    
    var numberOfSections: Int {
        return 1
    }
    
    var numberOfDays: Int {
        return weatherData.count
    }
    
    private func format(temperature: Double) -> String {
        switch UserDefaults.temperatureMode() {
        case .celcius:
            return String(format: "%.0f ℃", temperature.toCelcius())
        case .fahrenheit:
            return String(format: "%.0f °F", temperature)
        }
    }
}
