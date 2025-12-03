//
//  WeatherData.swift
//  WeatherCompare
//
//  Created on 2025-12-03
//

import Foundation

struct WeatherData: Codable {
    let temperature: Double
    let feelsLike: Double
    let humidity: Int
    let description: String
    let icon: String
    let windSpeed: Double
    let pressure: Int
    let date: Date

    var temperatureCelsius: Int {
        Int(temperature)
    }

    var temperatureFahrenheit: Int {
        Int(temperature * 9/5 + 32)
    }
}

struct WeatherComparison {
    let today: WeatherData
    let lastYear: WeatherData

    var temperatureDifference: Double {
        today.temperature - lastYear.temperature
    }

    var humidityDifference: Int {
        today.humidity - lastYear.humidity
    }

    var isWarmer: Bool {
        temperatureDifference > 0
    }

    var isSignificantChange: Bool {
        abs(temperatureDifference) > 5.0
    }

    var comparisonText: String {
        let diff = abs(temperatureDifference)
        if diff < 2 {
            return "Similar to last year"
        } else if isWarmer {
            return "\(Int(diff))° warmer than last year"
        } else {
            return "\(Int(diff))° cooler than last year"
        }
    }
}

// Response models for OpenWeatherMap API
struct OpenWeatherResponse: Codable {
    let main: MainWeather
    let weather: [Weather]
    let wind: Wind
    let dt: TimeInterval

    struct MainWeather: Codable {
        let temp: Double
        let feelsLike: Double
        let humidity: Int
        let pressure: Int

        enum CodingKeys: String, CodingKey {
            case temp
            case feelsLike = "feels_like"
            case humidity
            case pressure
        }
    }

    struct Weather: Codable {
        let description: String
        let icon: String
    }

    struct Wind: Codable {
        let speed: Double
    }

    func toWeatherData() -> WeatherData {
        WeatherData(
            temperature: main.temp,
            feelsLike: main.feelsLike,
            humidity: main.humidity,
            description: weather.first?.description.capitalized ?? "Unknown",
            icon: weather.first?.icon ?? "01d",
            windSpeed: wind.speed,
            pressure: main.pressure,
            date: Date(timeIntervalSince1970: dt)
        )
    }
}
