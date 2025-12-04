#!/usr/bin/env python3
"""
Weather Data Viewer

Helper script to view and analyze collected weather data.
"""

import json
import sys
from pathlib import Path
from datetime import datetime, timedelta
from collections import defaultdict


def list_cities():
    """List all cities with weather data."""
    weather_dir = Path("weather-data")
    if not weather_dir.exists():
        print("No weather data directory found.")
        return []

    cities = [d.name for d in weather_dir.iterdir() if d.is_dir() and not d.name.startswith('.')]
    return cities


def view_daily(city: str, date: str = None):
    """View weather data for a specific day."""
    if date is None:
        date = datetime.now().strftime("%Y-%m-%d")

    file_path = Path(f"weather-data/{city}/daily/{date}.json")

    if not file_path.exists():
        print(f"No data found for {city} on {date}")
        return

    with open(file_path, 'r') as f:
        data = json.load(f)

    print("\n" + "=" * 60)
    print(f"Weather Data for {data['city']} - {data['date']}")
    print("=" * 60)
    print(f"Temperature:  {data['temperature']}°C")
    print(f"Feels like:   {data['feels_like']}°C")
    print(f"Humidity:     {data['humidity']}%")
    print(f"Pressure:     {data['pressure']} hPa")
    print(f"Wind speed:   {data['wind_speed']} m/s")
    print(f"Condition:    {data['description']}")
    print(f"Recorded:     {data['timestamp']}")
    print("=" * 60 + "\n")


def view_monthly(city: str, year: str = None, month: str = None):
    """View monthly statistics."""
    if year is None:
        year = datetime.now().strftime("%Y")
    if month is None:
        month = datetime.now().strftime("%m")

    file_path = Path(f"weather-data/{city}/{year}/{year}-{month}.json")

    if not file_path.exists():
        print(f"No data found for {city} in {year}-{month}")
        return

    with open(file_path, 'r') as f:
        data = json.load(f)

    entries = data['entries']
    temps = [e['temperature']['current'] for e in entries]
    humidity = [e['atmospheric']['humidity'] for e in entries]

    print("\n" + "=" * 60)
    print(f"Monthly Statistics for {data['city']} - {year}-{month}")
    print("=" * 60)
    print(f"Total entries: {len(entries)}")
    print(f"\nTemperature:")
    print(f"  Average:  {sum(temps) / len(temps):.1f}°C")
    print(f"  Max:      {max(temps):.1f}°C")
    print(f"  Min:      {min(temps):.1f}°C")
    print(f"\nHumidity:")
    print(f"  Average:  {sum(humidity) / len(humidity):.0f}%")
    print(f"  Max:      {max(humidity)}%")
    print(f"  Min:      {min(humidity)}%")
    print("=" * 60 + "\n")


def compare_dates(city: str, date1: str, date2: str):
    """Compare weather between two dates."""
    file1 = Path(f"weather-data/{city}/daily/{date1}.json")
    file2 = Path(f"weather-data/{city}/daily/{date2}.json")

    if not file1.exists() or not file2.exists():
        print(f"Data not available for both dates")
        return

    with open(file1) as f:
        data1 = json.load(f)
    with open(file2) as f:
        data2 = json.load(f)

    temp_diff = data1['temperature'] - data2['temperature']
    humidity_diff = data1['humidity'] - data2['humidity']

    print("\n" + "=" * 60)
    print(f"Weather Comparison for {city}")
    print("=" * 60)
    print(f"\n{date1}:")
    print(f"  Temperature: {data1['temperature']}°C")
    print(f"  Humidity: {data1['humidity']}%")
    print(f"  Condition: {data1['description']}")

    print(f"\n{date2}:")
    print(f"  Temperature: {data2['temperature']}°C")
    print(f"  Humidity: {data2['humidity']}%")
    print(f"  Condition: {data2['description']}")

    print(f"\nDifference:")
    print(f"  Temperature: {temp_diff:+.1f}°C {'(warmer)' if temp_diff > 0 else '(cooler)' if temp_diff < 0 else '(same)'}")
    print(f"  Humidity: {humidity_diff:+d}% {'(more humid)' if humidity_diff > 0 else '(less humid)' if humidity_diff < 0 else '(same)'}")
    print("=" * 60 + "\n")


def list_available_dates(city: str):
    """List all available dates for a city."""
    daily_dir = Path(f"weather-data/{city}/daily")

    if not daily_dir.exists():
        print(f"No daily data found for {city}")
        return

    dates = sorted([f.stem for f in daily_dir.glob("*.json")])

    if not dates:
        print(f"No data files found for {city}")
        return

    print("\n" + "=" * 60)
    print(f"Available dates for {city}")
    print("=" * 60)
    print(f"Total days: {len(dates)}")
    print(f"From: {dates[0]}")
    print(f"To: {dates[-1]}")
    print("\nRecent dates:")
    for date in dates[-10:]:
        print(f"  - {date}")
    print("=" * 60 + "\n")


def main():
    """Main CLI interface."""
    if len(sys.argv) < 2:
        print("Weather Data Viewer")
        print("\nUsage:")
        print("  python scripts/view_weather_data.py list")
        print("  python scripts/view_weather_data.py daily <city> [date]")
        print("  python scripts/view_weather_data.py monthly <city> [year] [month]")
        print("  python scripts/view_weather_data.py compare <city> <date1> <date2>")
        print("  python scripts/view_weather_data.py dates <city>")
        print("\nExamples:")
        print("  python scripts/view_weather_data.py list")
        print("  python scripts/view_weather_data.py daily stockholm")
        print("  python scripts/view_weather_data.py daily stockholm 2025-12-03")
        print("  python scripts/view_weather_data.py monthly goteborg 2025 12")
        print("  python scripts/view_weather_data.py compare stockholm 2025-12-03 2024-12-03")
        print("  python scripts/view_weather_data.py dates stockholm")
        sys.exit(1)

    command = sys.argv[1]

    if command == "list":
        cities = list_cities()
        if cities:
            print("\nAvailable cities:")
            for city in cities:
                print(f"  - {city}")
            print()
        else:
            print("No cities with weather data found.")

    elif command == "daily":
        if len(sys.argv) < 3:
            print("Error: City name required")
            sys.exit(1)
        city = sys.argv[2]
        date = sys.argv[3] if len(sys.argv) > 3 else None
        view_daily(city, date)

    elif command == "monthly":
        if len(sys.argv) < 3:
            print("Error: City name required")
            sys.exit(1)
        city = sys.argv[2]
        year = sys.argv[3] if len(sys.argv) > 3 else None
        month = sys.argv[4] if len(sys.argv) > 4 else None
        view_monthly(city, year, month)

    elif command == "compare":
        if len(sys.argv) < 5:
            print("Error: City name and two dates required")
            print("Usage: python scripts/view_weather_data.py compare <city> <date1> <date2>")
            sys.exit(1)
        city = sys.argv[2]
        date1 = sys.argv[3]
        date2 = sys.argv[4]
        compare_dates(city, date1, date2)

    elif command == "dates":
        if len(sys.argv) < 3:
            print("Error: City name required")
            sys.exit(1)
        city = sys.argv[2]
        list_available_dates(city)

    else:
        print(f"Unknown command: {command}")
        print("Use 'list', 'daily', 'monthly', 'compare', or 'dates'")
        sys.exit(1)


if __name__ == "__main__":
    main()
