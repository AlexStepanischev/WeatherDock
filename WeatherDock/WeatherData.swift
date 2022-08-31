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
    @Published var dailyForecast = DailyForecast(day_data: [DayData()])

    @Published var updater = true
    
    @AppStorage("getDataBy") var getDataBy = DefaultSettings.getDataBy
    @AppStorage("city") var city = "Unknown City"
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
        if hourlyForecast.getHourlyTrimmed().count < 24 || dailyForecast.getDailyTrimmed().count < 7 {
            getAllData()
        } else if hourlyForecast.hour_data[0].dt < Date.now.timeIntervalSince1970 - intervalForecastWeatherUpdate {
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
    
    func initData(){
        if city == "Unknown City" {
            getDataBy = GetDataBy.location.rawValue
        } else {
            if !LocationManager.shared.hasLocationPermission(){
                getDataBy = GetDataBy.city.rawValue
            }
        }
        getAllData()
    }
    
    //Getting all data based on location or city name
    func getAllData(){
        if getDataBy == GetDataBy.location.rawValue {
            LocationManager.shared.getDataByLocation()
        } else {
            loadAllDataByCity()
        }
    }
    
    //Calling API for loading all data by location
    func loadAllDataByLocation(location: CLLocation){
        self.location = location
        print("Get all data by location")
        OpenWeather.loadAllDataByLocation(location: location)
    }
    
    //Calling API for loading all data by city name
    private func loadAllDataByCity(){
        print("Get all data by city")
        OpenWeather.loadAllDataByCity(city: city)
    }
    
    //Calling API for refreshing current weather data
    func refreshCurrentWeatherData() {
        if getDataBy == GetDataBy.location.rawValue && LocationManager.shared.hasLocationPermission() {
            OpenWeather.refreshCurrentWeatherData(by: GetDataBy.location)
        } else if city != "Unknown City" {
            OpenWeather.refreshCurrentWeatherData(by: GetDataBy.city)
        }
    }
}
