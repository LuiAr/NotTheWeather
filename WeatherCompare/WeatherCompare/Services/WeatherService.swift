//
//  WeatherService.swift
//  WeatherCompare
//
//  Created on 2025-12-03
//

import Foundation
import CoreLocation

enum WeatherError: Error {
    case invalidURL
    case invalidResponse
    case apiKeyMissing
    case decodingError
    case networkError(Error)

    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid API URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .apiKeyMissing:
            return "API key is missing. Please add your OpenWeatherMap API key."
        case .decodingError:
            return "Failed to decode weather data"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        }
    }
}

class WeatherService: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?

    // Replace with your OpenWeatherMap API key
    // Get a free key at: https://openweathermap.org/api
    private let apiKey = "YOUR_API_KEY_HERE"
    private let baseURL = "https://api.openweathermap.org/data/2.5"

    func fetchCurrentWeather(latitude: Double, longitude: Double) async throws -> WeatherData {
        guard !apiKey.isEmpty && apiKey != "YOUR_API_KEY_HERE" else {
            throw WeatherError.apiKeyMissing
        }

        let urlString = "\(baseURL)/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=metric"

        guard let url = URL(string: urlString) else {
            throw WeatherError.invalidURL
        }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                throw WeatherError.invalidResponse
            }

            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let weatherResponse = try decoder.decode(OpenWeatherResponse.self, from: data)

            return weatherResponse.toWeatherData()
        } catch let error as WeatherError {
            throw error
        } catch {
            throw WeatherError.networkError(error)
        }
    }

    func fetchHistoricalWeather(latitude: Double, longitude: Double, date: Date) async throws -> WeatherData {
        guard !apiKey.isEmpty && apiKey != "YOUR_API_KEY_HERE" else {
            throw WeatherError.apiKeyMissing
        }

        let timestamp = Int(date.timeIntervalSince1970)
        let urlString = "https://api.openweathermap.org/data/3.0/onecall/timemachine?lat=\(latitude)&lon=\(longitude)&dt=\(timestamp)&appid=\(apiKey)&units=metric"

        guard let url = URL(string: urlString) else {
            throw WeatherError.invalidURL
        }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                throw WeatherError.invalidResponse
            }

            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let weatherResponse = try decoder.decode(HistoricalWeatherResponse.self, from: data)

            guard let historicalData = weatherResponse.data.first else {
                throw WeatherError.invalidResponse
            }

            return historicalData.toWeatherData()
        } catch let error as WeatherError {
            throw error
        } catch {
            throw WeatherError.networkError(error)
        }
    }

    // For demo purposes: generate mock data
    func fetchMockWeatherComparison() -> WeatherComparison {
        let today = WeatherData(
            temperature: 22.5,
            feelsLike: 21.0,
            humidity: 65,
            description: "Partly Cloudy",
            icon: "02d",
            windSpeed: 3.5,
            pressure: 1013,
            date: Date()
        )

        let lastYear = WeatherData(
            temperature: 18.0,
            feelsLike: 17.0,
            humidity: 70,
            description: "Cloudy",
            icon: "03d",
            windSpeed: 4.0,
            pressure: 1010,
            date: Calendar.current.date(byAdding: .year, value: -1, to: Date())!
        )

        return WeatherComparison(today: today, lastYear: lastYear)
    }
}

// Historical weather response model
struct HistoricalWeatherResponse: Codable {
    let data: [HistoricalData]

    struct HistoricalData: Codable {
        let dt: TimeInterval
        let temp: Double
        let feelsLike: Double
        let pressure: Int
        let humidity: Int
        let windSpeed: Double
        let weather: [WeatherDescription]

        enum CodingKeys: String, CodingKey {
            case dt
            case temp
            case feelsLike = "feels_like"
            case pressure
            case humidity
            case windSpeed = "wind_speed"
            case weather
        }

        func toWeatherData() -> WeatherData {
            WeatherData(
                temperature: temp,
                feelsLike: feelsLike,
                humidity: humidity,
                description: weather.first?.description.capitalized ?? "Unknown",
                icon: weather.first?.icon ?? "01d",
                windSpeed: windSpeed,
                pressure: pressure,
                date: Date(timeIntervalSince1970: dt)
            )
        }
    }

    struct WeatherDescription: Codable {
        let description: String
        let icon: String
    }
}
