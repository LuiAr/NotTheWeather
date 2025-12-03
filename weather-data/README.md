# Weather Data Storage

This directory contains historical weather data collected daily for Stockholm and Göteborg.

## Structure

```
weather-data/
├── stockholm/
│   ├── YYYY/                  # Year
│   │   └── YYYY-MM.json      # Monthly data file
│   └── daily/                 # Daily summaries
│       └── YYYY-MM-DD.json   # One file per day
└── goteborg/
    ├── YYYY/
    │   └── YYYY-MM.json
    └── daily/
        └── YYYY-MM-DD.json
```

## Data Format

### Monthly Files (YYYY-MM.json)

Contains all weather measurements for a given month:

```json
{
  "city": "Stockholm",
  "year": "2025",
  "month": "12",
  "entries": [
    {
      "timestamp": "2025-12-03T12:00:00+00:00",
      "date": "2025-12-03",
      "time": "12:00:00",
      "city": "Stockholm",
      "coordinates": {
        "latitude": 59.3293,
        "longitude": 18.0686
      },
      "temperature": {
        "current": 5.2,
        "feels_like": 3.1,
        "min": 4.0,
        "max": 6.5
      },
      "weather": {
        "main": "Clouds",
        "description": "scattered clouds",
        "icon": "03d"
      },
      "atmospheric": {
        "pressure": 1013,
        "humidity": 75,
        "visibility": 10000
      },
      "wind": {
        "speed": 3.5,
        "direction": 180,
        "gust": 5.0
      },
      "clouds": {
        "coverage": 40
      },
      "rain": {},
      "snow": {},
      "sunrise": "2025-12-03T07:45:00+00:00",
      "sunset": "2025-12-03T15:30:00+00:00"
    }
  ]
}
```

### Daily Summary Files (YYYY-MM-DD.json)

Simplified daily snapshot:

```json
{
  "date": "2025-12-03",
  "city": "Stockholm",
  "temperature": 5.2,
  "feels_like": 3.1,
  "humidity": 75,
  "description": "scattered clouds",
  "wind_speed": 3.5,
  "pressure": 1013,
  "timestamp": "2025-12-03T12:00:00+00:00"
}
```

## Usage in iOS App

To use this historical data in your iOS app:

1. **Fetch data from repository**:
   - Use GitHub's raw content API
   - Or bundle recent data with the app

2. **Parse JSON**:
   ```swift
   struct StoredWeatherData: Codable {
       let date: String
       let city: String
       let temperature: Double
       let humidity: Int
       let description: String
       // ... other fields
   }
   ```

3. **Compare with current weather**:
   ```swift
   // Fetch historical data from one year ago
   let lastYearDate = Calendar.current.date(byAdding: .year, value: -1, to: Date())
   // Load from weather-data/stockholm/daily/YYYY-MM-DD.json
   ```

## API Information

Data is collected using OpenWeatherMap's Current Weather API:
- **Endpoint**: `api.openweathermap.org/data/2.5/weather`
- **Collection time**: Daily at 12:00 UTC
- **Cities**:
  - Stockholm (59.3293°N, 18.0686°E)
  - Göteborg (57.7089°N, 11.9746°E)

## Automated Collection

Weather data is automatically collected via GitHub Actions:
- **Workflow**: `.github/workflows/daily-weather-fetch.yml`
- **Schedule**: Every day at 12:00 UTC
- **Script**: `scripts/fetch_weather.py`

## Manual Collection

To manually collect weather data:

```bash
# Set your API key
export OPENWEATHER_API_KEY='your_api_key_here'

# Run the collection script
python scripts/fetch_weather.py
```

## Data Analysis

With this historical data, you can:
- Compare current weather with past years
- Identify weather trends and patterns
- Detect unusual weather events
- Generate statistics (average temps, rain days, etc.)
- Build predictive models

## Notes

- All timestamps are in UTC
- Temperature is in Celsius
- Wind speed is in meters per second
- Pressure is in hPa (hectopascals)
- Visibility is in meters
- Data collection started: 2025-12-03

## Future Enhancements

- Add more Swedish cities
- Include weather alerts and warnings
- Add data aggregation (weekly/monthly averages)
- Create data visualization tools
- Add data validation and quality checks
