#!/usr/bin/env python3
"""
Daily Weather Data Fetcher

This script fetches current weather data for Stockholm and Göteborg
and stores it in a structured format for historical analysis.
"""

import os
import sys
import json
import requests
from datetime import datetime, timezone
from pathlib import Path


# City coordinates
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
    }
}

BASE_URL = "https://api.openweathermap.org/data/2.5/weather"


def fetch_weather_data(city_name: str, lat: float, lon: float, api_key: str) -> dict:
    """
    Fetch current weather data from OpenWeatherMap API.

    Args:
        city_name: Name of the city
        lat: Latitude
        lon: Longitude
        api_key: OpenWeatherMap API key

    Returns:
        Dictionary containing weather data
    """
    params = {
        "lat": lat,
        "lon": lon,
        "appid": api_key,
        "units": "metric"
    }

    try:
        response = requests.get(BASE_URL, params=params, timeout=10)
        response.raise_for_status()
        data = response.json()

        # Extract and structure the data
        weather_data = {
            "timestamp": datetime.now(timezone.utc).isoformat(),
            "date": datetime.now(timezone.utc).strftime("%Y-%m-%d"),
            "time": datetime.now(timezone.utc).strftime("%H:%M:%S"),
            "city": city_name,
            "coordinates": {
                "latitude": lat,
                "longitude": lon
            },
            "temperature": {
                "current": data["main"]["temp"],
                "feels_like": data["main"]["feels_like"],
                "min": data["main"]["temp_min"],
                "max": data["main"]["temp_max"]
            },
            "weather": {
                "main": data["weather"][0]["main"],
                "description": data["weather"][0]["description"],
                "icon": data["weather"][0]["icon"]
            },
            "atmospheric": {
                "pressure": data["main"]["pressure"],
                "humidity": data["main"]["humidity"],
                "visibility": data.get("visibility", None)
            },
            "wind": {
                "speed": data["wind"]["speed"],
                "direction": data["wind"].get("deg", None),
                "gust": data["wind"].get("gust", None)
            },
            "clouds": {
                "coverage": data["clouds"]["all"]
            },
            "rain": data.get("rain", {}),
            "snow": data.get("snow", {}),
            "sunrise": datetime.fromtimestamp(data["sys"]["sunrise"], tz=timezone.utc).isoformat(),
            "sunset": datetime.fromtimestamp(data["sys"]["sunset"], tz=timezone.utc).isoformat()
        }

        return weather_data

    except requests.exceptions.RequestException as e:
        print(f"Error fetching weather data for {city_name}: {e}", file=sys.stderr)
        raise
    except (KeyError, IndexError) as e:
        print(f"Error parsing weather data for {city_name}: {e}", file=sys.stderr)
        raise


def save_weather_data(city_key: str, weather_data: dict):
    """
    Save weather data to a JSON file organized by year and month.

    Args:
        city_key: City identifier (e.g., 'stockholm', 'goteborg')
        weather_data: Weather data dictionary
    """
    # Get current date components
    now = datetime.now(timezone.utc)
    year = now.strftime("%Y")
    month = now.strftime("%m")

    # Create directory structure
    data_dir = Path(f"weather-data/{city_key}/{year}")
    data_dir.mkdir(parents=True, exist_ok=True)

    # File path for this month's data
    file_path = data_dir / f"{year}-{month}.json"

    # Load existing data if file exists
    if file_path.exists():
        with open(file_path, "r", encoding="utf-8") as f:
            monthly_data = json.load(f)
    else:
        monthly_data = {
            "city": weather_data["city"],
            "year": year,
            "month": month,
            "entries": []
        }

    # Add new entry
    monthly_data["entries"].append(weather_data)

    # Save updated data
    with open(file_path, "w", encoding="utf-8") as f:
        json.dump(monthly_data, f, indent=2, ensure_ascii=False)

    print(f"✓ Saved weather data for {weather_data['city']} to {file_path}")


def create_daily_summary(city_key: str, weather_data: dict):
    """
    Create a simple daily summary file (one entry per day).

    Args:
        city_key: City identifier
        weather_data: Weather data dictionary
    """
    summary_dir = Path(f"weather-data/{city_key}/daily")
    summary_dir.mkdir(parents=True, exist_ok=True)

    date = weather_data["date"]
    file_path = summary_dir / f"{date}.json"

    # Create simplified summary
    summary = {
        "date": date,
        "city": weather_data["city"],
        "temperature": weather_data["temperature"]["current"],
        "feels_like": weather_data["temperature"]["feels_like"],
        "humidity": weather_data["atmospheric"]["humidity"],
        "description": weather_data["weather"]["description"],
        "wind_speed": weather_data["wind"]["speed"],
        "pressure": weather_data["atmospheric"]["pressure"],
        "timestamp": weather_data["timestamp"]
    }

    with open(file_path, "w", encoding="utf-8") as f:
        json.dump(summary, f, indent=2, ensure_ascii=False)

    print(f"✓ Created daily summary for {weather_data['city']}: {file_path}")


def main():
    """Main execution function."""
    # Get API key from environment
    api_key = os.environ.get("OPENWEATHER_API_KEY")

    if not api_key:
        print("Error: OPENWEATHER_API_KEY environment variable not set", file=sys.stderr)
        print("\nTo run this script locally:", file=sys.stderr)
        print("  export OPENWEATHER_API_KEY='your_api_key_here'", file=sys.stderr)
        print("  python scripts/fetch_weather.py", file=sys.stderr)
        sys.exit(1)

    print("=" * 60)
    print(f"Weather Data Collection - {datetime.now(timezone.utc).strftime('%Y-%m-%d %H:%M:%S UTC')}")
    print("=" * 60)

    # Fetch and save data for each city
    for city_key, city_info in CITIES.items():
        print(f"\nFetching weather data for {city_info['name']}...")

        try:
            weather_data = fetch_weather_data(
                city_info["name"],
                city_info["lat"],
                city_info["lon"],
                api_key
            )

            # Save to monthly file
            save_weather_data(city_key, weather_data)

            # Save daily summary
            create_daily_summary(city_key, weather_data)

            # Print summary
            print(f"  Temperature: {weather_data['temperature']['current']}°C")
            print(f"  Condition: {weather_data['weather']['description']}")
            print(f"  Humidity: {weather_data['atmospheric']['humidity']}%")

        except Exception as e:
            print(f"✗ Failed to process {city_info['name']}: {e}", file=sys.stderr)
            sys.exit(1)

    print("\n" + "=" * 60)
    print("✓ Weather data collection completed successfully")
    print("=" * 60)


if __name__ == "__main__":
    main()
