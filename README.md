# WeatherCompare 🌤️

A beautiful iOS app that compares today's weather with last year's weather for the same day. Built with SwiftUI and featuring a modern liquid glass design.

## Features ✨

- **Simple & Clean**: No login required, just launch and see the comparison
- **Weather Comparison**: Compare today's weather with the same day last year
- **Liquid Glass Design**: Modern iOS design with beautiful glassmorphism effects
- **Visual Indicators**: Easy-to-understand indicators showing if weather is typical or unusual
- **Detailed Metrics**: Temperature, humidity, wind speed, and more
- **Location-Based**: Automatically uses your current location

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

Open `WeatherCompare/WeatherCompare/Services/WeatherService.swift` and replace `YOUR_API_KEY_HERE` with your actual API key:

```swift
private let apiKey = "your_actual_api_key_here"
```

### 4. Open in Xcode

```bash
cd WeatherCompare
open WeatherCompare.xcodeproj
```

Or if using Xcode 15+, you can open the folder directly as it contains Swift Package Manager support.

### 5. Build and Run

1. Select your target device or simulator
2. Press `Cmd + R` to build and run
3. Allow location permissions when prompted

## Project Structure

```
WeatherCompare/
├── WeatherCompare/
│   ├── WeatherCompareApp.swift      # App entry point
│   ├── ContentView.swift            # Main view
│   ├── Models/
│   │   └── WeatherData.swift        # Data models
│   ├── Services/
│   │   ├── WeatherService.swift     # API service
│   │   └── LocationManager.swift    # Location handling
│   ├── Views/
│   │   ├── GlassCard.swift          # Reusable glass components
│   │   ├── WeatherCardView.swift    # Individual weather cards
│   │   └── ComparisonIndicatorView.swift  # Comparison UI
│   └── Resources/
│       ├── Assets.xcassets/         # App assets
│       └── Info.plist               # App configuration
└── Package.swift                     # Swift Package Manager
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