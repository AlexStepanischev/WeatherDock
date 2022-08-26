//
//  NetworkHelper.swift
//  WeatherDock
//
//  Created by Aleksandr Stepanischev on 05/05/2022.
//

import SwiftUI
import CoreLocation

struct Network {
    private static let openWeatherApi = "https://api.openweathermap.org/data/2.5/"
    @AppStorage("unitsOfMeasurement") private static var unitsOfMeasurement = DefaultSettings.unitsOfMeasurement
    
    static func getCoordURL(lat: Double, lon: Double) -> URL {
        let latitude = String(format: "%f", lat)
        let longitude = String(format: "%f", lon)
        
        let url_string = "\(openWeatherApi)weather?lat=\(latitude)&lon=\(longitude)&appid=\(getApiKey())&units=\(unitsOfMeasurement)"

        let url = URL(string: url_string)!
        return url
    }
    
    static func getCityURL(city: String) -> URL {
        let city_escaped = city.addingPercentEncoding(withAllowedCharacters: .alphanumerics)!
        let url_string = "\(openWeatherApi)weather?q=\(city_escaped)&appid=\(getApiKey())&units=\(unitsOfMeasurement)"
        
        let url = URL(string: url_string)!
        return url
    }
    
    static func getOneCallUrl(lat: Double, lon: Double) -> URL {
        let latitude = String(format: "%f", lat)
        let longitude = String(format: "%f", lon)
        
        let url_string = "\(openWeatherApi)onecall?lat=\(latitude)&lon=\(longitude)&appid=\(getApiKey())&units=\(unitsOfMeasurement)&exclude=current,minutely,alerts"

        let url = URL(string: url_string)!
        return url
    }
    
    static func getAirPollutionUrl(lat: Double, lon: Double) -> URL {
        let latitude = String(format: "%f", lat)
        let longitude = String(format: "%f", lon)
        
        let url_string = "\(openWeatherApi)air_pollution?lat=\(latitude)&lon=\(longitude)&appid=\(getApiKey())"

        let url = URL(string: url_string)!
        return url
    }
    
    static func getCurrentWeatherData(url: URL) async -> CurrentWeatherData {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let decodedResponse = try? JSONDecoder().decode(CurrentWeatherData.self, from: data){
                return decodedResponse
            }
        } catch {
            print("Issues with getting data form API")
            print(error)
        }
        return CurrentWeatherData.getEmpty()
    }
    
    static func getAirPollutionData(url: URL) async -> AirPollutionData {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let decodedResponse = try? JSONDecoder().decode(AirPollutionData.self, from: data){
                return decodedResponse
            }
        } catch {
            print("Issues with getting data form API")
            print(error)
        }
        return AirPollutionData.getEmpty()
    }
    
    static func getForecastData(url: URL) async -> ForecastData {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let decodedResponse = try? JSONDecoder().decode(ForecastData.self, from: data){
                return decodedResponse
            }
        } catch {
            print("Issues with getting data form API")
            print(error)
        }
        return ForecastData.getEmpty()
    }
    
    static func getApiKey() -> String {
        var keys: NSDictionary?
        
        if let path = Bundle.main.path(forResource: "keys", ofType: "plist") {
            keys = NSDictionary(contentsOfFile: path)
        }
        
        if let dict = keys {
            return dict["openweather_api_key"] as? String ?? ""
        }
        
        return ""
    }
    
    static func loadAllDataByLocation(location: CLLocation){
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        Task {
            let updatedCurrentWeatherData = await Network.getCurrentWeatherData(url: Network.getCoordURL(lat: latitude, lon: longitude))
            let updatedAirPollutionData = await Network.getAirPollutionData(url: Network.getAirPollutionUrl(lat: latitude, lon: longitude))
            let updatedForecastData = await Network.getForecastData(url: Network.getOneCallUrl(lat: latitude, lon: longitude))
            
            print("All weather updated at: \(Utils.getDateTimefromUnix(dt: updatedCurrentWeatherData.dt, timezone: updatedCurrentWeatherData.timezone))")
            
            DispatchQueue.main.async {
                let weatherData = WeatherData.shared
                weatherData.currentWeatherData = updatedCurrentWeatherData
                weatherData.airPollutionData = updatedAirPollutionData
                weatherData.forecastData = updatedForecastData
                weatherData.city = updatedCurrentWeatherData.name
                AppDelegate.updateMenuButton()
            }
        }
    }
    
    static func loadAllDataByCity(city: String){
        Task {
            let updatedCurrentWeatherData = await Network.getCurrentWeatherData(url: Network.getCityURL(city: city))
            
            let latitude = updatedCurrentWeatherData.coord.lat
            let longitude = updatedCurrentWeatherData.coord.lon
            
            let weatherData = WeatherData.shared
            var location = weatherData.location
            
            location = CLLocation(latitude: latitude, longitude: longitude)
            
            //var locationOld = weatherData.locationOld
            //locationOld = (latitude, longitude)
            
            let loc = (location.coordinate.latitude, location.coordinate.longitude)
                        
            if loc == (0.0, 0.0) {
                DispatchQueue.main.async {
                    weatherData.currentWeatherData = CurrentWeatherData.getEmpty()
                    weatherData.airPollutionData = AirPollutionData.getEmpty()
                    weatherData.forecastData = ForecastData.getEmpty()
                    weatherData.refreshView()
                }
            } else {
                let updatedAirPollutionData = await Network.getAirPollutionData(url: Network.getAirPollutionUrl(lat: latitude, lon: longitude))
                let updatedforecastData = await Network.getForecastData(url: Network.getOneCallUrl(lat: latitude, lon: longitude))
                
                print("All weather updated at: \(Utils.getDateTimefromUnix(dt: updatedCurrentWeatherData.dt, timezone: updatedCurrentWeatherData.timezone))")
                
                DispatchQueue.main.async {
                    weatherData.currentWeatherData = updatedCurrentWeatherData
                    weatherData.airPollutionData = updatedAirPollutionData
                    weatherData.forecastData = updatedforecastData
                    weatherData.city = updatedCurrentWeatherData.name
                    AppDelegate.updateMenuButton()
                }
            }
        }
    }
    
    static func refreshCurrentWeatherData() {
        let weatherData = WeatherData.shared
        let city = weatherData.city
        let location = weatherData.location
        
        //let locationOld = weatherData.locationOld
        
        var url_var = Network.getCoordURL(lat: location.coordinate.latitude, lon: location.coordinate.longitude)
        if weatherData.getDataBy == GetDataBy.city.rawValue {
            url_var = Network.getCityURL(city: city)
        }
        
        let url = url_var

        Task {
            let updatedCurrentWeatherData = await Network.getCurrentWeatherData(url: url)

            print("Current weather updated at: \(Utils.getDateTimefromUnix(dt: updatedCurrentWeatherData.dt, timezone: updatedCurrentWeatherData.timezone))")
            
            let updatedAirPollutionData = await Network.getAirPollutionData(url: Network.getAirPollutionUrl(lat: updatedCurrentWeatherData.coord.lat, lon: updatedCurrentWeatherData.coord.lon))

            DispatchQueue.main.async {
                weatherData.currentWeatherData = updatedCurrentWeatherData
                weatherData.airPollutionData = updatedAirPollutionData
                AppDelegate.updateMenuButton()
            }
        }
    }
}
