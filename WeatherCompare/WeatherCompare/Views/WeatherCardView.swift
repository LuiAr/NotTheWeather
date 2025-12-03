//
//  WeatherCardView.swift
//  WeatherCompare
//
//  Created on 2025-12-03
//

import SwiftUI

struct WeatherCardView: View {
    let weather: WeatherData
    let title: String
    let accentColor: Color

    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 16) {
                // Header
                HStack {
                    Text(title)
                        .font(.headline)
                        .foregroundStyle(.secondary)

                    Spacer()

                    Image(systemName: weatherIcon)
                        .font(.title2)
                        .foregroundStyle(accentColor)
                }

                // Main temperature
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text("\(weather.temperatureCelsius)")
                        .font(.system(size: 64, weight: .bold, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [accentColor, accentColor.opacity(0.7)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )

                    Text("°C")
                        .font(.title)
                        .foregroundStyle(.secondary)
                        .padding(.bottom, 8)
                }

                // Description
                Text(weather.description)
                    .font(.title3)
                    .fontWeight(.medium)

                Divider()
                    .background(.white.opacity(0.3))

                // Additional details
                VStack(spacing: 12) {
                    WeatherDetailRow(
                        icon: "thermometer.medium",
                        label: "Feels like",
                        value: "\(Int(weather.feelsLike))°C"
                    )

                    WeatherDetailRow(
                        icon: "humidity.fill",
                        label: "Humidity",
                        value: "\(weather.humidity)%"
                    )

                    WeatherDetailRow(
                        icon: "wind",
                        label: "Wind",
                        value: String(format: "%.1f m/s", weather.windSpeed)
                    )
                }
            }
        }
    }

    private var weatherIcon: String {
        // Map common weather conditions to SF Symbols
        let desc = weather.description.lowercased()
        if desc.contains("clear") || desc.contains("sunny") {
            return "sun.max.fill"
        } else if desc.contains("cloud") {
            return "cloud.fill"
        } else if desc.contains("rain") {
            return "cloud.rain.fill"
        } else if desc.contains("snow") {
            return "snowflake"
        } else if desc.contains("storm") || desc.contains("thunder") {
            return "cloud.bolt.fill"
        } else {
            return "cloud.sun.fill"
        }
    }
}

struct WeatherDetailRow: View {
    let icon: String
    let label: String
    let value: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.body)
                .foregroundStyle(.secondary)
                .frame(width: 24)

            Text(label)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Spacer()

            Text(value)
                .font(.subheadline)
                .fontWeight(.semibold)
        }
    }
}

#Preview {
    ZStack {
        GlassBackground()

        WeatherCardView(
            weather: WeatherData(
                temperature: 22.5,
                feelsLike: 21.0,
                humidity: 65,
                description: "Partly Cloudy",
                icon: "02d",
                windSpeed: 3.5,
                pressure: 1013,
                date: Date()
            ),
            title: "Today",
            accentColor: .blue
        )
        .padding()
    }
}
