# Quick Start Guide

Get the WeatherCompare app running in 5 minutes!

## Option 1: Run with Demo Data (Fastest)

No API key required! The app includes mock data for testing.

1. **Open the project**
   ```bash
   cd WeatherCompare
   open WeatherCompare.xcodeproj
   ```

2. **Run the app**
   - Select iPhone 15 Pro simulator (or any iOS 17+ device)
   - Press `⌘ + R` (Cmd + R)

3. **Done!** The app will show demo weather comparison data

## Option 2: Run with Real Weather Data

### Prerequisites
- iOS device or simulator with location services
- OpenWeatherMap API key

### Steps

1. **Get API Key**
   - Visit https://openweathermap.org/api
   - Sign up (free)
   - Copy your API key

2. **Add API Key**
   - Open `WeatherCompare/Services/WeatherService.swift`
   - Replace line 25:
     ```swift
     private let apiKey = "YOUR_API_KEY_HERE"
     ```
     with:
     ```swift
     private let apiKey = "your_actual_key_here"
     ```

3. **Enable Production Mode**
   - Open `ContentView.swift`
   - Go to the `loadWeatherData()` function (around line 177)
   - Comment out demo code:
     ```swift
     // Task {
     //     await Task.sleep(1_000_000_000)
     //     await MainActor.run {
     //         weatherComparison = weatherService.fetchMockWeatherComparison()
     //         isLoading = false
     //     }
     // }
     ```
   - Uncomment production code (lines 186-224)

4. **Run**
   - Press `⌘ + R`
   - Allow location permissions

### Important Notes

⚠️ **Historical Data Limitation**:
- The free OpenWeatherMap API only provides current weather
- Historical weather (needed for year-over-year comparison) requires a paid subscription (~$40/month)
- For testing without subscription, use Demo Mode

## Project Files Overview

```
WeatherCompare/
├── WeatherCompareApp.swift           # App entry point
├── ContentView.swift                 # Main view (toggle demo/production here)
├── Models/
│   └── WeatherData.swift            # Data structures
├── Services/
│   ├── WeatherService.swift         # API calls (add API key here)
│   └── LocationManager.swift        # Location handling
└── Views/
    ├── GlassCard.swift              # UI components
    ├── WeatherCardView.swift        # Weather cards
    └── ComparisonIndicatorView.swift # Comparison UI
```

## Troubleshooting

### "Unable to get your location"
- Check location permissions in Settings
- Make sure you're running on a real device or simulator with location enabled

### "API key is missing"
- Verify you replaced `YOUR_API_KEY_HERE` with your actual key
- Ensure there are no extra spaces or quotes

### Build errors
- Make sure you're using Xcode 15+
- Select iOS 17+ deployment target
- Clean build folder: `⌘ + Shift + K`

## Next Steps

1. Try the demo mode first
2. Customize the UI colors in `GlassCard.swift`
3. Adjust the "unusual weather" threshold in `WeatherData.swift`
4. Add your own features!

## Need Help?

- Check the main [README.md](README.md) for detailed documentation
- Open an issue on GitHub
- Review the inline code comments

Happy coding! 🚀
