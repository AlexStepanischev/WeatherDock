//
//  NetworkHelper.swift
//  OpenWeather
//
//  Created by Aleksandr Stepanischev on 05/05/2022.
//

import SwiftUI

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
}
