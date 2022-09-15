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
    let geoCoder = CLGeocoder()

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
    
    func getTimezoneFrom(location: CLLocation, completion: @escaping (_ placemark: [CLPlacemark]?, _ error: Error?) -> Void)  {
        CLGeocoder().reverseGeocodeLocation(location) { placemark, error in
            guard let placemark = placemark, error == nil else {
                completion(nil, error)
                return
            }
            completion(placemark, nil)
        }
    }
    
    func getLocationFrom(cityName: String,
            completionHandler: @escaping(CLLocation, NSError?) -> Void ) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(cityName) { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?[0] {
                    let location = placemark.location!
                        
                    completionHandler(location, nil)
                    return
                }
            }
                
            completionHandler(CLLocation(latitude: 0.0, longitude: 0.0), error as NSError?)
        }
    }
    
}
