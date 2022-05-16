//
//  LocationManager.swift
//  OpenWeather
//
//  Created by Aleksandr Stepanischev on 06/05/2022.
//

import Foundation
import CoreLocation
import SwiftUI

class LocationManager: NSObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()

    var location: CLLocationCoordinate2D?
    
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
        location = locations.last?.coordinate
        manager.stopUpdatingLocation()
        
        let latitude = location?.latitude ?? 0.0
        let longitude = location?.longitude ?? 0.0
        
        WeatherData.shared.updateAllDataByCoords(latitude: latitude, longitude: longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Swift.Error) {
        print(error)
    }
}
