//
//  LocationManager.swift
//  WeatherCompare
//
//  Created on 2025-12-03
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()

    @Published var location: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus?
    @Published var errorMessage: String?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        self.location = location
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        errorMessage = "Failed to get location: \(error.localizedDescription)"
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
    }
}
