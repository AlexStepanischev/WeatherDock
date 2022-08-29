//
//  NetworkHelper.swift
//  WeatherDock
//
//  Created by Aleksandr Stepanischev on 05/05/2022.
//

import SwiftUI
import CoreLocation

struct OpenWeather {
    private static let openWeatherApi = "https://api.openweathermap.org/data/2.5/"
    @AppStorage("unitsOfMeasurement") private static var unitsOfMeasurement = DefaultSettings.unitsOfMeasurement
    
    //Building url for getting current weather by location
    private static func getCurrentWeatherByLocationURL(location: CLLocation) -> URL {
        let latitude = String(format: "%f", location.coordinate.latitude)
        let longitude = String(format: "%f", location.coordinate.longitude)
        
        let url_string = "\(openWeatherApi)weather?lat=\(latitude)&lon=\(longitude)&appid=\(getApiKey())&units=\(unitsOfMeasurement)"

        return URL(string: url_string)!
    }
    
    //Building url for getting current weather by city name
    private static func getCurrentWeatherByCityURL(city: String) -> URL {
        let city_escaped = city.addingPercentEncoding(withAllowedCharacters: .alphanumerics)!
        let url_string = "\(openWeatherApi)weather?q=\(city_escaped)&appid=\(getApiKey())&units=\(unitsOfMeasurement)"
        
        return URL(string: url_string)!
    }
    
    //Building url for getting hourly and daily forecasts via OneCall API
    private static func getOneCallUrl(location: CLLocation) -> URL {
        let latitude = String(format: "%f", location.coordinate.latitude)
        let longitude = String(format: "%f", location.coordinate.longitude)
        
        let url_string = "\(openWeatherApi)onecall?lat=\(latitude)&lon=\(longitude)&appid=\(getApiKey())&units=\(unitsOfMeasurement)&exclude=current,minutely,alerts"

        return URL(string: url_string)!
    }
    
    //Building url for getting air pollution data
    private static func getAirPollutionUrl(location: CLLocation) -> URL {
        let latitude = String(format: "%f", location.coordinate.latitude)
        let longitude = String(format: "%f", location.coordinate.longitude)
        
        let url_string = "\(openWeatherApi)air_pollution?lat=\(latitude)&lon=\(longitude)&appid=\(getApiKey())"

        return URL(string: url_string)!
    }
    
    //Getting API Key form keys.plist
    private static func getApiKey() -> String {
        var keys: NSDictionary?
        
        if let path = Bundle.main.path(forResource: "keys", ofType: "plist") {
            keys = NSDictionary(contentsOfFile: path)
        }
        
        if let dict = keys {
            return dict["openweather_api_key"] as? String ?? ""
        }
        
        return ""
    }
    
    //Loading all data by location
    static func loadAllDataByLocation(location: CLLocation){
        Task {
            let updatedCurrentWeatherData = await getCurrentWeatherData(url: getCurrentWeatherByLocationURL(location: location))
            let updatedAirPollutionData = await getAirPollutionData(location: location)
            let updatedForecastData = await getForecastData(location: location)
            
            print("All weather updated by location at: \(Utils.getDateTimefromUnix(dt: updatedCurrentWeatherData.dt, timezone: updatedCurrentWeatherData.timezone))")
            
            DispatchQueue.main.async {
                let weatherData = WeatherData.shared
                updateCurrentWeatherWith(data: updatedCurrentWeatherData)
                updateAirPollutionWith(data: updatedAirPollutionData)
                weatherData.forecastData = updatedForecastData
                weatherData.city = updatedCurrentWeatherData.name
                AppDelegate.updateMenuButton()
            }
        }
    }
    
    //Loading all data by city, if city is unknown returns zero data
    static func loadAllDataByCity(city: String){
        Task {
            let updatedCurrentWeatherData = await OpenWeather.getCurrentWeatherData(url: getCurrentWeatherByCityURL(city: city))
            
            let weatherData = WeatherData.shared
            var location = weatherData.location
            
            location = CLLocation(latitude: updatedCurrentWeatherData.coord.lat, longitude: updatedCurrentWeatherData.coord.lon)
                        
            if (location.coordinate.latitude, location.coordinate.longitude) == (0.0, 0.0) {
                DispatchQueue.main.async {
                    updateCurrentWeatherWith(data: CurrentWeatherResponse.getEmpty())
                    updateAirPollutionWith(data: AirPollutionResponse.getEmpty())
                    weatherData.forecastData = ForecastData.getEmpty()
                    weatherData.refreshView()
                }
            } else {
                let updatedAirPollutionData = await getAirPollutionData(location: location)
                let updatedforecastData = await getForecastData(location: location)
                
                print("All weather updated by city at: \(Utils.getDateTimefromUnix(dt: updatedCurrentWeatherData.dt, timezone: updatedCurrentWeatherData.timezone))")
                
                DispatchQueue.main.async {
                    updateCurrentWeatherWith(data: updatedCurrentWeatherData)
                    updateAirPollutionWith(data: updatedAirPollutionData)
                    weatherData.forecastData = updatedforecastData
                    weatherData.city = updatedCurrentWeatherData.name
                    AppDelegate.updateMenuButton()
                }
            }
        }
    }
    
    //Refreshing current weather data based on GetDataBy setting
    static func refreshCurrentWeatherData() {
        let weatherData = WeatherData.shared
        let city = weatherData.city
        let location = weatherData.location
                
        var url_var = getCurrentWeatherByLocationURL(location: location)
        if weatherData.getDataBy == GetDataBy.city.rawValue {
            url_var = getCurrentWeatherByCityURL(city: city)
        }
        
        let url = url_var

        Task {
            let updatedCurrentWeatherData = await getCurrentWeatherData(url: url)
            let new_location = CLLocation(latitude: updatedCurrentWeatherData.coord.lat, longitude: updatedCurrentWeatherData.coord.lon)

            print("Current weather updated at: \(Utils.getDateTimefromUnix(dt: updatedCurrentWeatherData.dt, timezone: updatedCurrentWeatherData.timezone))")
            
            let updatedAirPollutionData = await getAirPollutionData(location: new_location)

            DispatchQueue.main.async {
                updateCurrentWeatherWith(data: updatedCurrentWeatherData)
                updateAirPollutionWith(data: updatedAirPollutionData)
                weatherData.location = new_location
                AppDelegate.updateMenuButton()
            }
        }
    }
    
    //Performs Api call and data decoding for current weather data, returns zero data in case of error
    private static func getCurrentWeatherData(url: URL) async -> CurrentWeatherResponse {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let decodedResponse = try? JSONDecoder().decode(CurrentWeatherResponse.self, from: data){
                return decodedResponse
            }
        } catch {
            print("Issues with getting data form API")
            print(error)
        }
        return CurrentWeatherResponse.getEmpty()
    }
    
    //Performs Api call and data decoding for air pollution data, returns zero data in case of error
    private static func getAirPollutionData(location: CLLocation) async -> AirPollutionResponse {
        let url = getAirPollutionUrl(location: location)
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let decodedResponse = try? JSONDecoder().decode(AirPollutionResponse.self, from: data){
                return decodedResponse
            }
        } catch {
            print("Issues with getting data form API")
            print(error)
        }
        return AirPollutionResponse.getEmpty()
    }
    
    //Performs Api call and data decoding for one call forecast data, returns zero data in case of error
    private static func getForecastData(location: CLLocation) async -> ForecastData {
        let url = getOneCallUrl(location: location)
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
    
    //Updating current weather data with received data
    private static func updateCurrentWeatherWith(data: CurrentWeatherResponse){
        var newCurrentWeather = CurrentWeather()
        newCurrentWeather.dt = data.dt
        newCurrentWeather.timezone = data.timezone
        newCurrentWeather.temperature = Int(data.main.temp.rounded())
        newCurrentWeather.temp_unit = Utils.getTempMeasurement()
        newCurrentWeather.description = data.weather[0].description.firstCapitalized
        newCurrentWeather.short_desc = data.weather[0].main
        newCurrentWeather.feels_like = Int(data.main.feels_like.rounded())
        newCurrentWeather.sunrise = data.sys.sunrise
        newCurrentWeather.sunset = data.sys.sunset
        newCurrentWeather.humidity = data.main.humidity
        newCurrentWeather.wind_speed = Int(data.wind.speed.rounded())
        newCurrentWeather.wind_unit = Utils.getSpeedMeasurement()
        newCurrentWeather.pressure = data.main.pressure
        newCurrentWeather.city = data.name
        
        WeatherData.shared.currentWeather = newCurrentWeather
        WeatherData.shared.currentWeather.icon = Utils.getIconByTimeConditionId(id: data.weather[0].id, dt: data.dt)
    }
    
    //Updating air pollution data with received data
    private static func updateAirPollutionWith(data: AirPollutionResponse){
        var newAirPollution = AirPollution()
        
        if !data.list.isEmpty {
            newAirPollution.aqi = data.list[0].main.aqi
            newAirPollution.aqi_icon = Utils.aqi[data.list[0].main.aqi]?.1 ?? "aqi.low"
            newAirPollution.aqi_text = Utils.aqi[data.list[0].main.aqi]?.0 ?? "Unknown"
            
            let airComponents = data.list[0].components
            var pollutants = Pollutants()
            
            if let co = airComponents.co {
                pollutants.co = String(format: "%.1f", co)
            }
            
            if let no = airComponents.no {
                pollutants.no = String(format: "%.1f", no)
            }
            
            if let no2 = airComponents.no2 {
                pollutants.no2 = String(format: "%.1f", no2)
            }
            
            if let o3 = airComponents.o3 {
                pollutants.o3 = String(format: "%.1f", o3)
            }
            
            if let so2 = airComponents.so2 {
                pollutants.so2 = String(format: "%.1f", so2)
            }
            
            if let pm2_5 = airComponents.pm2_5 {
                pollutants.pm2_5 = String(format: "%.1f", pm2_5)
            }
            
            if let pm10 = airComponents.pm10 {
                pollutants.pm10 = String(format: "%.1f", pm10)
            }
            
            if let nh3 = airComponents.nh3 {
                pollutants.nh3 = String(format: "%.1f", nh3)
            }
            
            newAirPollution.pollutants = pollutants
        }
                
        WeatherData.shared.airPollution = newAirPollution
    }
}
