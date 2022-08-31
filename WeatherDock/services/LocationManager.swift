//
//  LocationManager.swift
//  WeatherDock
//
//  Created by Aleksandr Stepanischev on 06/05/2022.
//

import Foundation
import CoreLocation
import SwiftUI

class LocationManager: NSObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()
    
    static let shared = LocationManager()

    private override init() {
        super.init()
        manager.delegate = self
    }

    func getDataByLocation() {
        manager.desiredAccuracy = kCLLocationAccuracyKilometer;
        manager.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        
        let location = locations.last ?? CLLocation(latitude: 0.0, longitude: 0.0)
        
        WeatherData.shared.loadAllDataByLocation(location: location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Swift.Error) {
        print(error)
    }
    
    func hasLocationPermission() -> Bool {
        var hasPermission = false
        let manager = CLLocationManager()
        
        if CLLocationManager.locationServicesEnabled() {
            switch manager.authorizationStatus {
            case .notDetermined, .restricted, .denied:
                hasPermission = false
            case .authorizedAlways, .authorizedWhenInUse:
                hasPermission = true
            @unknown default:
                    break
            }
        } else {
            hasPermission = false
        }
        
        return hasPermission
    }
}
