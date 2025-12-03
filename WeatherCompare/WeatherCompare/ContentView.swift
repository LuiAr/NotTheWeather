//
//  ContentView.swift
//  WeatherCompare
//
//  Created on 2025-12-03
//

import SwiftUI

struct ContentView: View {
    @StateObject private var locationManager = LocationManager()
    @StateObject private var weatherService = WeatherService()

    @State private var weatherComparison: WeatherComparison?
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var showingSettings = false

    var body: some View {
        ZStack {
            GlassBackground()

            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    headerView

                    if isLoading {
                        loadingView
                    } else if let error = errorMessage {
                        errorView(error)
                    } else if let comparison = weatherComparison {
                        weatherContentView(comparison)
                    } else {
                        emptyStateView
                    }
                }
                .padding()
                .padding(.top, 20)
            }
        }
        .onAppear {
            loadWeatherData()
        }
    }

    // MARK: - Header
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Weather Compare")
                    .font(.system(size: 34, weight: .bold, design: .rounded))

                Text(formattedDate)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Button(action: {
                loadWeatherData()
            }) {
                Image(systemName: "arrow.clockwise")
                    .font(.title2)
                    .foregroundStyle(.white)
                    .padding(12)
                    .background(
                        Circle()
                            .fill(.ultraThinMaterial)
                    )
            }
        }
    }

    // MARK: - Loading View
    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.5)
                .tint(.white)

            Text("Fetching weather data...")
                .font(.headline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 100)
    }

    // MARK: - Error View
    private func errorView(_ message: String) -> some View {
        GlassCard {
            VStack(spacing: 16) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 50))
                    .foregroundStyle(.orange)

                Text("Unable to Load Weather")
                    .font(.title2)
                    .fontWeight(.bold)

                Text(message)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)

                Button(action: {
                    loadWeatherData()
                }) {
                    Text("Try Again")
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(
                            Capsule()
                                .fill(.blue)
                        )
                }
                .padding(.top, 8)
            }
            .padding()
        }
    }

    // MARK: - Empty State View
    private var emptyStateView: some View {
        GlassCard {
            VStack(spacing: 16) {
                Image(systemName: "cloud.sun.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.blue, .cyan],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )

                Text("Compare Weather")
                    .font(.title2)
                    .fontWeight(.bold)

                Text("See how today's weather compares to last year")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)

                Button(action: {
                    loadWeatherData()
                }) {
                    HStack {
                        Image(systemName: "location.fill")
                        Text("Get Weather")
                    }
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [.blue, .cyan],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                    )
                }
                .padding(.top, 8)
            }
            .padding()
        }
    }

    // MARK: - Weather Content
    private func weatherContentView(_ comparison: WeatherComparison) -> some View {
        VStack(spacing: 24) {
            // Comparison indicator
            ComparisonIndicatorView(comparison: comparison)

            // Today's weather
            WeatherCardView(
                weather: comparison.today,
                title: "Today",
                accentColor: .blue
            )

            // Last year's weather
            WeatherCardView(
                weather: comparison.lastYear,
                title: "Last Year (Same Day)",
                accentColor: .purple
            )
        }
    }

    // MARK: - Helpers
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"
        return formatter.string(from: Date())
    }

    private func loadWeatherData() {
        isLoading = true
        errorMessage = nil

        // For demo purposes, use mock data
        // In production, you would use real API calls with user's location
        Task {
            await Task.sleep(1_000_000_000) // 1 second delay for demo

            await MainActor.run {
                weatherComparison = weatherService.fetchMockWeatherComparison()
                isLoading = false
            }
        }

        // Uncomment below for real API integration
        /*
        locationManager.requestLocation()

        Task {
            do {
                guard let location = locationManager.location else {
                    await MainActor.run {
                        errorMessage = "Unable to get your location. Please enable location services."
                        isLoading = false
                    }
                    return
                }

                let latitude = location.coordinate.latitude
                let longitude = location.coordinate.longitude

                // Fetch today's weather
                let today = try await weatherService.fetchCurrentWeather(
                    latitude: latitude,
                    longitude: longitude
                )

                // Calculate date one year ago
                let calendar = Calendar.current
                let lastYearDate = calendar.date(byAdding: .year, value: -1, to: Date())!

                // Fetch last year's weather
                let lastYear = try await weatherService.fetchHistoricalWeather(
                    latitude: latitude,
                    longitude: longitude,
                    date: lastYearDate
                )

                await MainActor.run {
                    weatherComparison = WeatherComparison(today: today, lastYear: lastYear)
                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    isLoading = false
                }
            }
        }
        */
    }
}

#Preview {
    ContentView()
}
