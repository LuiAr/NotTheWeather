//
//  ComparisonIndicatorView.swift
//  WeatherCompare
//
//  Created on 2025-12-03
//

import SwiftUI

struct ComparisonIndicatorView: View {
    let comparison: WeatherComparison

    var body: some View {
        GlassCard {
            VStack(spacing: 16) {
                // Comparison icon and title
                HStack {
                    Image(systemName: comparisonIcon)
                        .font(.title2)
                        .foregroundStyle(comparisonColor)

                    Text("Weather Comparison")
                        .font(.headline)

                    Spacer()
                }

                // Visual comparison bar
                ComparisonBar(comparison: comparison)

                // Text description
                Text(comparison.comparisonText)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(comparisonColor)

                // Unusual indicator
                if comparison.isSignificantChange {
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundStyle(.orange)

                        Text("Unusual weather for this time of year")
                            .font(.subheadline)
                            .fontWeight(.medium)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        Capsule()
                            .fill(.orange.opacity(0.2))
                    )
                } else {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.green)

                        Text("Typical weather for this time of year")
                            .font(.subheadline)
                            .fontWeight(.medium)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        Capsule()
                            .fill(.green.opacity(0.2))
                    )
                }

                // Additional metrics
                HStack(spacing: 24) {
                    MetricChangeView(
                        icon: "thermometer",
                        label: "Temp",
                        change: comparison.temperatureDifference,
                        unit: "°"
                    )

                    MetricChangeView(
                        icon: "humidity",
                        label: "Humidity",
                        change: Double(comparison.humidityDifference),
                        unit: "%"
                    )
                }
            }
        }
    }

    private var comparisonIcon: String {
        if abs(comparison.temperatureDifference) < 2 {
            return "equal.circle.fill"
        } else if comparison.isWarmer {
            return "arrow.up.circle.fill"
        } else {
            return "arrow.down.circle.fill"
        }
    }

    private var comparisonColor: Color {
        if abs(comparison.temperatureDifference) < 2 {
            return .green
        } else if comparison.isWarmer {
            return .red
        } else {
            return .blue
        }
    }
}

struct ComparisonBar: View {
    let comparison: WeatherComparison

    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 4) {
                ForEach(0..<10) { index in
                    Rectangle()
                        .fill(barColor(for: index))
                        .frame(height: 8)
                }
            }
            .clipShape(Capsule())

            HStack {
                Text("Cooler")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Spacer()

                Text("Similar")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Spacer()

                Text("Warmer")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private func barColor(for index: Int) -> Color {
        let diff = comparison.temperatureDifference
        let normalizedDiff = max(-10, min(10, diff)) // Clamp between -10 and 10
        let position = (normalizedDiff + 10) / 2 // Convert to 0-10 range

        if Double(index) < position {
            return comparison.isWarmer ? .red.opacity(0.7) : .blue.opacity(0.7)
        } else if abs(Double(index) - position) < 0.5 {
            return .white
        } else {
            return .gray.opacity(0.3)
        }
    }
}

struct MetricChangeView: View {
    let icon: String
    let label: String
    let change: Double
    let unit: String

    var body: some View {
        VStack(spacing: 4) {
            HStack(spacing: 2) {
                Image(systemName: icon)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text(label)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            HStack(spacing: 2) {
                Image(systemName: change > 0 ? "arrow.up" : (change < 0 ? "arrow.down" : "minus"))
                    .font(.caption)
                    .foregroundStyle(changeColor)

                Text("\(abs(Int(change)))\(unit)")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(changeColor)
            }
        }
    }

    private var changeColor: Color {
        if abs(change) < 1 {
            return .secondary
        } else if change > 0 {
            return .red
        } else {
            return .blue
        }
    }
}

#Preview {
    ZStack {
        GlassBackground()

        ComparisonIndicatorView(
            comparison: WeatherComparison(
                today: WeatherData(
                    temperature: 28.5,
                    feelsLike: 27.0,
                    humidity: 65,
                    description: "Sunny",
                    icon: "01d",
                    windSpeed: 3.5,
                    pressure: 1013,
                    date: Date()
                ),
                lastYear: WeatherData(
                    temperature: 22.0,
                    feelsLike: 21.0,
                    humidity: 70,
                    description: "Cloudy",
                    icon: "03d",
                    windSpeed: 4.0,
                    pressure: 1010,
                    date: Calendar.current.date(byAdding: .year, value: -1, to: Date())!
                )
            )
        )
        .padding()
    }
}
