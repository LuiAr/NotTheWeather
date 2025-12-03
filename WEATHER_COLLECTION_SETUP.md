# Weather Data Collection Setup Guide

This guide explains how to set up and use the automated weather data collection system.

## Overview

The system automatically collects weather data for Stockholm and Göteborg every day at 12:00 UTC using GitHub Actions. Data is stored in the `weather-data/` directory and committed back to the repository.

## Quick Setup

### 1. Get OpenWeatherMap API Key

1. Visit [OpenWeatherMap](https://openweathermap.org/api)
2. Sign up for a free account
3. Go to "API keys" section
4. Copy your API key

### 2. Add API Key to GitHub Secrets

1. Go to your GitHub repository
2. Navigate to **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**
4. Name: `OPENWEATHER_API_KEY`
5. Value: Paste your API key
6. Click **Add secret**

### 3. Enable GitHub Actions

1. Go to the **Actions** tab in your repository
2. If prompted, enable GitHub Actions for the repository
3. The workflow will automatically start running daily

## Manual Trigger

You can manually trigger the weather collection:

1. Go to **Actions** tab
2. Select **Daily Weather Data Collection** workflow
3. Click **Run workflow**
4. Click the green **Run workflow** button

## Local Testing

To test the collection script locally:

```bash
# Install Python dependencies
pip install requests

# Set your API key
export OPENWEATHER_API_KEY='your_api_key_here'

# Run the script
python scripts/fetch_weather.py

# Check the generated data
ls -la weather-data/stockholm/
ls -la weather-data/goteborg/
```

## Workflow Details

### Schedule
- **Frequency**: Daily at 12:00 UTC (2:00 PM CET)
- **Cron expression**: `0 12 * * *`

To change the schedule, edit `.github/workflows/daily-weather-fetch.yml`:

```yaml
schedule:
  - cron: '0 12 * * *'  # Change this line
```

Cron format: `minute hour day month weekday`

Examples:
- `0 6 * * *` - Run at 6:00 UTC
- `0 */6 * * *` - Run every 6 hours
- `0 12,18 * * *` - Run at 12:00 and 18:00 UTC

### Cities

Currently collecting data for:
- **Stockholm**: 59.3293°N, 18.0686°E
- **Göteborg**: 57.7089°N, 11.9746°E

To add more cities, edit `scripts/fetch_weather.py`:

```python
CITIES = {
    "stockholm": {
        "name": "Stockholm",
        "lat": 59.3293,
        "lon": 18.0686
    },
    "goteborg": {
        "name": "Göteborg",
        "lat": 57.7089,
        "lon": 11.9746
    },
    "malmo": {  # Add new city
        "name": "Malmö",
        "lat": 55.6050,
        "lon": 13.0038
    }
}
```

## Data Storage

### Directory Structure

```
weather-data/
├── stockholm/
│   ├── 2025/
│   │   ├── 2025-01.json    # January data
│   │   ├── 2025-02.json    # February data
│   │   └── ...
│   └── daily/
│       ├── 2025-01-01.json
│       ├── 2025-01-02.json
│       └── ...
└── goteborg/
    └── (same structure)
```

### File Formats

**Monthly files** (`YYYY-MM.json`):
- Contains all entries for the month
- Detailed weather information
- Multiple entries per day (if script runs multiple times)

**Daily files** (`YYYY-MM-DD.json`):
- One summary per day
- Simplified format for quick access
- Overwrites if script runs multiple times per day

## Using the Data in Your iOS App

### Option 1: Bundle with App

Include recent weather data files in your Xcode project:

```swift
func loadHistoricalWeather(city: String, date: Date) -> WeatherData? {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    let dateString = formatter.string(from: date)

    guard let url = Bundle.main.url(
        forResource: "weather-data/\(city)/daily/\(dateString)",
        withExtension: "json"
    ) else { return nil }

    let data = try? Data(contentsOf: url)
    let weather = try? JSONDecoder().decode(StoredWeatherData.self, from: data)
    return weather
}
```

### Option 2: Fetch from GitHub

Load data directly from the repository:

```swift
func fetchHistoricalWeather(city: String, date: Date) async throws -> WeatherData {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    let dateString = formatter.string(from: date)

    let urlString = "https://raw.githubusercontent.com/yourusername/NotTheWeather/main/weather-data/\(city)/daily/\(dateString).json"

    let url = URL(string: urlString)!
    let (data, _) = try await URLSession.shared.data(from: url)
    return try JSONDecoder().decode(WeatherData.self, from: data)
}
```

### Option 3: GitHub API

Use GitHub's API to list and fetch files:

```swift
// List all daily files for a city
let apiUrl = "https://api.github.com/repos/yourusername/NotTheWeather/contents/weather-data/stockholm/daily"
```

## Monitoring

### Check Workflow Status

1. Go to **Actions** tab
2. View recent workflow runs
3. Click on a run to see detailed logs
4. Check for any errors or failures

### Verify Data Collection

Check if new files are being created:

```bash
# View recent commits
git log --oneline --grep="weather data"

# Check latest data
cat weather-data/stockholm/daily/$(date +%Y-%m-%d).json
```

## Troubleshooting

### Workflow Not Running

1. Check if Actions are enabled in repository settings
2. Verify the workflow file syntax
3. Check if the schedule expression is correct
4. Ensure repository has proper permissions

### API Key Errors

```
Error: OPENWEATHER_API_KEY environment variable not set
```

**Solution**: Add the API key to GitHub Secrets (see step 2 above)

### Rate Limiting

OpenWeatherMap free tier limits:
- **60 calls/minute**
- **1,000,000 calls/month**

Our usage: ~60 calls/month (2 cities × 1 time/day)

Well within limits!

### Permission Errors

```
Error: Permission denied
```

**Solution**: Ensure the workflow has `contents: write` permission:

```yaml
permissions:
  contents: write
```

### Network Errors

If API calls fail, the workflow will:
1. Log the error
2. Exit with error code
3. Not commit any data
4. Retry next day automatically

## Cost Analysis

### OpenWeatherMap API
- **Free tier**: ✓ Sufficient
- **Calls needed**: ~60/month
- **Cost**: $0/month

### GitHub Actions
- **Free tier**: 2,000 minutes/month
- **Usage**: ~2 minutes/month
- **Cost**: $0/month

### Storage
- **Data size**: ~5 KB per day
- **Yearly**: ~1.8 MB/city
- **GitHub limit**: 1 GB (free)
- **Cost**: $0/month

**Total monthly cost: $0** 🎉

## Advanced Configuration

### Collect Multiple Times Per Day

Edit the cron schedule:

```yaml
schedule:
  - cron: '0 6,12,18 * * *'  # 6 AM, 12 PM, 6 PM UTC
```

### Add Data Validation

Modify `scripts/fetch_weather.py` to add validation:

```python
def validate_weather_data(data: dict) -> bool:
    # Add custom validation logic
    if data["temperature"]["current"] < -50 or data["temperature"]["current"] > 50:
        return False
    return True
```

### Send Notifications

Add a notification step to the workflow:

```yaml
- name: Notify on failure
  if: failure()
  run: |
    curl -X POST "https://hooks.slack.com/..." \
      -d '{"text":"Weather collection failed!"}'
```

### Archive Old Data

Create a monthly archive workflow:

```yaml
- name: Archive old data
  run: |
    # Move files older than 6 months to archive/
    find weather-data -name "*.json" -mtime +180 -exec mv {} archive/ \;
```

## Data Analysis Examples

### Calculate Monthly Average

```python
import json
from pathlib import Path

def monthly_average(city: str, year: str, month: str):
    file_path = Path(f"weather-data/{city}/{year}/{year}-{month}.json")
    with open(file_path) as f:
        data = json.load(f)

    temps = [entry["temperature"]["current"] for entry in data["entries"]]
    return sum(temps) / len(temps)

# Usage
avg = monthly_average("stockholm", "2025", "12")
print(f"Average temperature: {avg:.1f}°C")
```

### Find Extreme Weather

```python
def find_extremes(city: str, year: str):
    extremes = {
        "hottest": {"temp": -999, "date": None},
        "coldest": {"temp": 999, "date": None}
    }

    daily_dir = Path(f"weather-data/{city}/daily")
    for file in daily_dir.glob(f"{year}-*.json"):
        with open(file) as f:
            data = json.load(f)

        temp = data["temperature"]
        if temp > extremes["hottest"]["temp"]:
            extremes["hottest"] = {"temp": temp, "date": data["date"]}
        if temp < extremes["coldest"]["temp"]:
            extremes["coldest"] = {"temp": temp, "date": data["date"]}

    return extremes
```

## Contributing

To improve the weather collection system:

1. Fork the repository
2. Make your changes
3. Test locally with `python scripts/fetch_weather.py`
4. Submit a pull request

## License

This weather collection system is part of the WeatherCompare project and follows the same MIT License.

## Support

For issues or questions:
- Open a GitHub issue
- Check the Actions logs for error details
- Verify API key is correctly set

---

**Last updated**: 2025-12-03
