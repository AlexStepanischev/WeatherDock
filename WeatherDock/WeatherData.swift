//
//  WeatherData.swift
//  WeatherDock
//
//  Created by Aleksandr Stepanischev on 06/05/2022.
//

import SwiftUI
import CoreLocation

class WeatherData: ObservableObject {
    @Published var currentWeather = CurrentWeather()
    @Published var airPollution = AirPollution()
    @Published var hourlyForecast = HourlyForecast(hour_data: [HourData()])
    
    @Published var forecastData = ForecastData.getEmpty()
    @Published var updater = true
    
    @AppStorage("getDataBy") var getDataBy = DefaultSettings.getDataBy
    @AppStorage("city") var city = ""
    @Published var location = CLLocation(latitude: 0.0, longitude: 0.0)
    
    static let shared = WeatherData()
    
    let intervalCurrentWeatherBackgroundUpdate: Double = 3600 //1h
    let intervalCurrentWeatherUpdate: Double = 1200 //20m
    let intervalForecastWeatherUpdate: Double = 86400 //24h
    
    var timer: Timer?
    
    private init() {
        setTimer()
    }
    
    //Timer for current weather data refresh
    func setTimer(){
        timer = Timer.scheduledTimer(withTimeInterval: intervalCurrentWeatherBackgroundUpdate, repeats: true, block: { _ in
            self.refreshCurrentWeatherData()
        })
    }
    
    //Updates data according to update intervals
    func updateUIData(){
        if forecastData.getHourlyTrimmed().count < 24 || forecastData.getDailyTrimmed().count < 7 {
            getAllData()
        } else if forecastData.hourly[0].dt < Date.now.timeIntervalSince1970 - intervalForecastWeatherUpdate {
            getAllData()
        } else if currentWeather.dt < Date.now.timeIntervalSince1970 - intervalCurrentWeatherUpdate {
            refreshCurrentWeatherData()
            refreshView()
        } else {
            refreshView()
        }
    }
    
    //Main view and button refresher
    func refreshView(){
        objectWillChange.send()
        updater.toggle()
        AppDelegate.updateMenuButton()
    }
    
    //Getting all data based on location or city name
    func getAllData(){
        if getDataBy == GetDataBy.location.rawValue {
            LocationManager.shared.getDataByLocation()
            print("Get all data by location")
        } else {
            loadAllDataByCity()
            print("Get all data by city")
        }
    }
    
    //Calling API for loading all data by location
    func loadAllDataByLocation(location: CLLocation){
        self.location = location
        
        OpenWeather.loadAllDataByLocation(location: location)
    }
    
    //Calling API for loading all data by city name
    private func loadAllDataByCity(){
        OpenWeather.loadAllDataByCity(city: city)
    }
    
    //Calling API for refreshing current weather data
    func refreshCurrentWeatherData() {
        OpenWeather.refreshCurrentWeatherData()
    }
}
