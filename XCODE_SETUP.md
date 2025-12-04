# Xcode Setup Guide

This guide will help you set up the WeatherCompare app in Xcode and configure environment variables for the API key.

## Prerequisites

- Xcode 15.0 or later
- macOS with support for iOS 17+
- OpenWeatherMap API key ([Get one here](https://openweathermap.org/api))

## Opening the Project

### Option 1: Open as Folder (Recommended for Xcode 15+)

1. Open Xcode
2. Go to **File → Open**
3. Navigate to the `NotTheWeather/WeatherCompare` folder
4. Select the **WeatherCompare** folder (not the root NotTheWeather folder)
5. Click **Open**

Xcode will automatically detect the Swift source files and set up the project.

### Option 2: Create Xcode Project (If Needed)

If opening as a folder doesn't work:

1. Open Xcode
2. Create a new iOS App project
3. Replace the generated files with the files from `WeatherCompare/WeatherCompare/`

## Setting Up Environment Variables in Xcode

The app now uses environment variables for the API key instead of hardcoding it in the source code. This is more secure and makes it easier to manage different keys for development and production.

### Step-by-Step Instructions

1. **Open your Xcode project**

2. **Select the scheme**
   - Click on the scheme selector at the top (next to the run/stop buttons)
   - It should show "WeatherCompare" or your app name
   - Click **Edit Scheme...** or press `Cmd + <`

3. **Navigate to Run settings**
   - In the left sidebar, select **Run**
   - Make sure you're on the **Arguments** tab

4. **Add Environment Variable**
   - Under **Environment Variables** section, click the **+** button
   - Add a new variable:
     - **Name**: `OPENWEATHER_API_KEY`
     - **Value**: `your_actual_api_key_here` (paste your OpenWeatherMap API key)

5. **Enable the variable**
   - Make sure the checkbox next to the variable is **checked**

6. **Close the scheme editor**
   - Click **Close** to save your changes

### Visual Guide

```
Edit Scheme → Run → Arguments → Environment Variables → +

┌─────────────────────────────────────────────────────┐
│ Environment Variables                                │
│ ┌─────────────────────────────────────────────────┐ │
│ │ ☑ OPENWEATHER_API_KEY  your_api_key_here       │ │
│ └─────────────────────────────────────────────────┘ │
│                                         [+]  [-]     │
└─────────────────────────────────────────────────────┘
```

## Getting an OpenWeatherMap API Key

1. Go to [OpenWeatherMap](https://openweathermap.org/api)
2. Sign up for a free account
3. Navigate to your API keys section
4. Generate a new API key
5. Copy the key and use it in Xcode's environment variables

### API Tiers

- **Free Tier**: Includes current weather data (perfect for getting started)
- **One Call API 3.0** (Paid): Required for historical weather data (~$40/month)

## Running the App

1. **Select a simulator or device**
   - Choose an iPhone simulator or connected device from the device selector
   - Requires iOS 17.0 or later

2. **Build and run**
   - Press `Cmd + R` or click the **Run** button (▶)
   - The app will build and launch

3. **Grant location permissions**
   - When prompted, allow the app to access your location
   - This is required for fetching weather data for your current location

## Demo Mode

The app includes a demo mode with mock data, so you can test the UI without setting up an API key:

- The app will automatically use mock data if no API key is configured
- To enable real weather data, make sure you've set the `OPENWEATHER_API_KEY` environment variable

## Troubleshooting

### "API key is missing" Error

**Solution**: Make sure you've set the `OPENWEATHER_API_KEY` environment variable in your Xcode scheme (see instructions above)

### "Invalid response from server" Error

**Possible causes**:
- Invalid API key
- Network connectivity issues
- API rate limit reached (free tier: 60 calls/minute)

**Solution**:
- Verify your API key is correct
- Check your internet connection
- Wait a few minutes if you've hit the rate limit

### "Failed to decode weather data" Error

**Solution**: This usually means the API response format changed. Check the OpenWeatherMap API documentation for updates.

### Build Errors

**"Source files for target should be located under 'Sources/WeatherCompare'"**

**Solution**: This error has been fixed by removing the unnecessary `Package.swift` file. If you still see it:
1. Close Xcode
2. Delete the `Package.swift` file if it exists
3. Delete any derived data: `rm -rf ~/Library/Developer/Xcode/DerivedData`
4. Reopen the project in Xcode

### Location Not Working

**Solution**:
- Make sure you've granted location permissions in the iOS simulator/device settings
- Check that location services are enabled on your device
- In simulator: **Features → Location → Custom Location** or use a preset city

## Environment Variable Best Practices

### Security

1. **Never commit API keys to Git**
   - Environment variables in Xcode schemes are local to your machine
   - The `.gitignore` file already excludes Xcode user data

2. **Use different keys for development and production**
   - Create separate API keys for testing and production
   - Use Xcode schemes to manage different configurations

### Scheme Management

You can create multiple schemes for different environments:

1. **Development Scheme**: Uses test API key, demo data
2. **Production Scheme**: Uses production API key, real data

To create a new scheme:
1. **Product → Scheme → Manage Schemes**
2. Click **+** to add a new scheme
3. Configure environment variables for each scheme

## Additional Configuration

### Changing Cities

To test different locations without moving:

1. In Xcode, go to **Debug → Simulate Location**
2. Choose a preset city or use **Custom Location**
3. Enter latitude/longitude coordinates

### Mock Data vs Real Data

The app automatically determines whether to use mock or real data based on whether the API key is set. To force one or the other:

Edit `WeatherCompare/ContentView.swift` and modify the `loadWeatherData()` function.

## Next Steps

- Read [README.md](README.md) for app features and architecture
- Check [WEATHER_COLLECTION_SETUP.md](WEATHER_COLLECTION_SETUP.md) for automated data collection
- Review [QUICKSTART.md](QUICKSTART.md) for quick start guide

## Support

If you encounter issues:
1. Check this troubleshooting guide
2. Review the main [README.md](README.md)
3. Create an issue on GitHub with:
   - Xcode version
   - iOS version (simulator/device)
   - Complete error message
   - Steps to reproduce

---

**Remember**: Keep your API keys secure and never share them publicly!
