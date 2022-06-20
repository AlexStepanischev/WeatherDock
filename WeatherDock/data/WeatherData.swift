//
//  WeatherData.swift
//  OpenWeather
//
//  Created by Aleksandr Stepanischev on 06/05/2022.
//

import SwiftUI

class WeatherData: ObservableObject {
    @Published var currentWeatherData = CurrentWeatherData.getEmpty()
    @Published var forecastData = ForecastData.getEmpty()
    @Published var updater = true
    @AppStorage("getDataBy") private var getDataBy = DefaultSettings.getDataBy
    
    var intervalCurrentWeatherBackgroundUpdate: Double = 3600 //1h
    var intervalCurrentWeatherUpdate: Double = 1200 //20m
    var intervalForecastWeatherUpdate: Double = 86400 //24h
    
    var location = (0.0, 0.0)
    @AppStorage("city") var city = ""
    
    static let shared = WeatherData()
    
    var timer: Timer?
    
    private init() {
        timer = Timer.scheduledTimer(withTimeInterval: intervalCurrentWeatherBackgroundUpdate, repeats: true, block: { _ in
            self.refreshCurrentWeatherData()
        })
    }
    
    func refreshCurrentWeatherData() {
        var url_var = Network.getCoordURL(lat: location.0, lon: location.1)
        if getDataBy == GetDataBy.city.rawValue {
            url_var = Network.getCityURL(city: city)
        }
        
        let url = url_var

        Task {
            let updatedCurrentWeatherData = await Network.getCurrentWeatherData(url: url)

            print("Current weather updated at: \(Utils.getDateTimefromUnix(dt: updatedCurrentWeatherData.dt, timezone: updatedCurrentWeatherData.timezone))")

            DispatchQueue.main.async {
                self.currentWeatherData = updatedCurrentWeatherData
                AppDelegate.updateMenuButton(currentWeatherData: updatedCurrentWeatherData)
            }
        }
    }
    
    func updateAllDataByCoords(latitude: Double, longitude: Double){
        self.location = (latitude, longitude)
        
        Task {
            let updatedCurrentWeatherData = await Network.getCurrentWeatherData(url: Network.getCoordURL(lat: latitude, lon: longitude))
            let updatedForecastData = await Network.getForecastData(url: Network.getOneCallUrl(lat: latitude, lon: longitude))
            
            print("All weather updated at: \(Utils.getDateTimefromUnix(dt: updatedCurrentWeatherData.dt, timezone: updatedCurrentWeatherData.timezone))")
            
            DispatchQueue.main.async {
                self.currentWeatherData = updatedCurrentWeatherData
                self.forecastData = updatedForecastData
                self.city = updatedCurrentWeatherData.name
                AppDelegate.updateMenuButton(currentWeatherData: updatedCurrentWeatherData)
            }
        }
    }
    
    func refreshView(){
        objectWillChange.send()
        updater.toggle()
        AppDelegate.updateMenuButton(currentWeatherData: self.currentWeatherData)
    }
    
    func updateUIData(){
        if forecastData.getHourlyTrimmed().count < 24 || forecastData.getDailyTrimmed().count < 7 {
            getAllData()
        } else if forecastData.hourly[0].dt < Date.now.timeIntervalSince1970 - intervalForecastWeatherUpdate {
            getAllData()
        } else if currentWeatherData.dt < Date.now.timeIntervalSince1970 - intervalCurrentWeatherUpdate {
            refreshCurrentWeatherData()
            refreshView()
        } else {
            refreshView()
        }
    }
    
    func getDataByCity(){
        Task {
            let updatedCurrentWeatherData = await Network.getCurrentWeatherData(url: Network.getCityURL(city: city))
            
            let latitude = updatedCurrentWeatherData.coord.lat
            let longitude = updatedCurrentWeatherData.coord.lon
            
            location = (latitude, longitude)
            
            if location == (0.0, 0.0) {
                DispatchQueue.main.async {
                    self.currentWeatherData = CurrentWeatherData.getEmpty()
                    self.forecastData = ForecastData.getEmpty()
                    self.refreshView()
                }
            } else {
                let updatedforecastData = await Network.getForecastData(url: Network.getOneCallUrl(lat: latitude, lon: longitude))
                
                print("All weather updated at: \(Utils.getDateTimefromUnix(dt: updatedCurrentWeatherData.dt, timezone: updatedCurrentWeatherData.timezone))")
                
                DispatchQueue.main.async {
                    self.currentWeatherData = updatedCurrentWeatherData
                    self.forecastData = updatedforecastData
                    self.city = updatedCurrentWeatherData.name
                    AppDelegate.updateMenuButton(currentWeatherData: updatedCurrentWeatherData)
                }
            }
        }
    }
    
    func getAllData(){
        if getDataBy == GetDataBy.location.rawValue {
            LocationManager.shared.getDataByLocation()
            print("Get all data by location")
        } else {
            getDataByCity()
            print("Get all data by city")
        }
    }
    
}
