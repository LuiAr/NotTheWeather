# WeatherCompare 🌤️

A beautiful iOS app that compares today's weather with last year's weather for the same day. Built with SwiftUI and featuring a modern liquid glass design.

## Features ✨

- **Simple & Clean**: No login required, just launch and see the comparison
- **Weather Comparison**: Compare today's weather with the same day last year
- **Liquid Glass Design**: Modern iOS design with beautiful glassmorphism effects
- **Visual Indicators**: Easy-to-understand indicators showing if weather is typical or unusual
- **Detailed Metrics**: Temperature, humidity, wind speed, and more
- **Location-Based**: Automatically uses your current location
- **Automated Data Collection**: GitHub Actions automatically collects weather data daily for Stockholm and Göteborg

## Screenshots

The app features:
- Beautiful gradient background with floating orbs
- Glass-like cards with frosted effects
- Clear comparison indicators
- Visual temperature difference bars
- Unusual weather alerts when significant changes are detected

## Requirements

- iOS 17.0+
- Xcode 15.0+
- Swift 5.9+
- OpenWeatherMap API key (free tier available)

## Installation

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/NotTheWeather.git
cd NotTheWeather
```

### 2. Get an API Key

1. Go to [OpenWeatherMap](https://openweathermap.org/api)
2. Sign up for a free account
3. Generate an API key
4. Note: The free tier includes current weather data. For historical data comparison, you'll need the "One Call API 3.0" subscription.

### 3. Configure the API Key

The app now uses **environment variables** for the API key (more secure than hardcoding):

1. Open the `WeatherCompare` folder in Xcode
2. Edit the app scheme: **Product → Scheme → Edit Scheme** (or `Cmd + <`)
3. Go to **Run → Arguments → Environment Variables**
4. Add a new variable:
   - **Name**: `OPENWEATHER_API_KEY`
   - **Value**: Your actual API key
5. Make sure the checkbox is **enabled**

For detailed instructions with screenshots, see [XCODE_SETUP.md](XCODE_SETUP.md)

### 4. Open in Xcode

```bash
cd WeatherCompare
```

Then in Xcode:
- **File → Open** and select the `WeatherCompare` folder (Xcode 15+)

### 5. Build and Run

1. Select your target device or simulator (iOS 17.0+)
2. Press `Cmd + R` to build and run
3. Allow location permissions when prompted

**Note**: The app works without an API key using demo data. Set the environment variable to use real weather data.

## Project Structure

```
WeatherCompare/
└── WeatherCompare/
    ├── WeatherCompareApp.swift      # App entry point
    ├── ContentView.swift            # Main view
    ├── Models/
    │   └── WeatherData.swift        # Data models
    ├── Services/
    │   ├── WeatherService.swift     # API service (uses env variables)
    │   └── LocationManager.swift    # Location handling
    ├── Views/
    │   ├── GlassCard.swift          # Reusable glass components
    │   ├── WeatherCardView.swift    # Individual weather cards
    │   └── ComparisonIndicatorView.swift  # Comparison UI
    └── Resources/
        ├── Assets.xcassets/         # App assets
        └── Info.plist               # App configuration
```

## Usage

### Demo Mode

By default, the app runs in demo mode with mock data. This allows you to see the UI without configuring an API key.

To enable demo mode, the `loadWeatherData()` function in `ContentView.swift` uses:

```swift
weatherComparison = weatherService.fetchMockWeatherComparison()
```

### Production Mode

To use real weather data:

1. Add your OpenWeatherMap API key to `WeatherService.swift`
2. In `ContentView.swift`, uncomment the production code block in `loadWeatherData()`
3. Comment out the demo mode code

**Note**: Historical weather data requires a paid OpenWeatherMap subscription (One Call API 3.0).

## API Information

### Current Weather API (Free)
- Endpoint: `api.openweathermap.org/data/2.5/weather`
- Provides: Current weather conditions
- Cost: Free

### Historical Weather API (Paid)
- Endpoint: `api.openweathermap.org/data/3.0/onecall/timemachine`
- Provides: Historical weather data
- Cost: Requires subscription (~$40/month for 1,000 calls/day)

### Alternative: Using Mock Data

For development or if you don't need real historical data, the app includes a mock data generator that creates realistic weather comparisons.

## Customization

### Colors

Modify the gradient colors in `GlassBackground.swift`:

```swift
LinearGradient(
    colors: [
        Color(red: 0.4, green: 0.6, blue: 1.0),  // Change these
        Color(red: 0.6, green: 0.8, blue: 1.0)   // values
    ],
    startPoint: .topLeading,
    endPoint: .bottomTrailing
)
```

### Comparison Thresholds

Adjust what's considered "unusual" weather in `WeatherData.swift`:

```swift
var isSignificantChange: Bool {
    abs(temperatureDifference) > 5.0  // Change this threshold
}
```

## Automated Weather Data Collection 🤖

This repository includes a GitHub Actions workflow that automatically collects weather data daily for Stockholm and Göteborg. This builds up historical data over time, eliminating the need for expensive historical weather API subscriptions!

### Features

- **Daily Collection**: Runs automatically every day at 12:00 UTC
- **Multiple Cities**: Stockholm and Göteborg (easily expandable)
- **Structured Storage**: Organized by city, year, and month
- **Free Historical Data**: Build your own historical weather database
- **No Maintenance**: Fully automated via GitHub Actions

### Quick Setup

1. Get a free [OpenWeatherMap API key](https://openweathermap.org/api)
2. Add it to GitHub Secrets as `OPENWEATHER_API_KEY`
3. Done! Data will be collected automatically

For detailed setup instructions, see [WEATHER_COLLECTION_SETUP.md](WEATHER_COLLECTION_SETUP.md)

### Data Structure

```
weather-data/
├── stockholm/
│   ├── 2025/2025-12.json    # Monthly detailed data
│   └── daily/2025-12-03.json # Daily summaries
└── goteborg/
    └── (same structure)
```

### Using Collected Data in the App

After a year of data collection, you can use the stored historical data instead of the paid API:

```swift
// Load last year's weather from stored data
let lastYearDate = Calendar.current.date(byAdding: .year, value: -1, to: Date())
let dateString = formatDate(lastYearDate) // "2024-12-03"

// Fetch from GitHub repository
let url = "https://raw.githubusercontent.com/yourusername/NotTheWeather/main/weather-data/stockholm/daily/\(dateString).json"
let historicalWeather = try await fetchFromURL(url)
```

### View Collected Data

Use the included viewer script:

```bash
# View today's weather
python scripts/view_weather_data.py daily stockholm

# View monthly statistics
python scripts/view_weather_data.py monthly stockholm 2025 12

# Compare two dates
python scripts/view_weather_data.py compare stockholm 2025-12-03 2024-12-03
```

See [weather-data/README.md](weather-data/README.md) for more details.

## Future Features 🚀

- Historical data caching
- Multiple location support
- Weather trends over multiple years
- Notifications for unusual weather
- Widget support
- Apple Watch companion app
- Dark mode optimization

## Architecture

The app follows SwiftUI best practices:

- **MVVM Pattern**: Clear separation of views and business logic
- **Observable Objects**: Reactive state management
- **Async/Await**: Modern Swift concurrency for API calls
- **Reusable Components**: Modular glass UI components
- **Type Safety**: Strong typing with Swift's type system

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is open source and available under the MIT License.

## Acknowledgments

- Weather data provided by [OpenWeatherMap](https://openweathermap.org/)
- SF Symbols for beautiful icons
- SwiftUI for the amazing UI framework

## Support

If you encounter any issues or have questions:

1. Check the [Issues](https://github.com/yourusername/NotTheWeather/issues) page
2. Create a new issue with details about your problem
3. Include your iOS version, Xcode version, and any error messages

## Author

Created with ❤️ for iOS developers who love beautiful weather apps

---

**Note**: This app is designed for iOS 17+ to take advantage of the latest SwiftUI features and visual effects. For older iOS versions, some adjustments to the UI code may be necessary.