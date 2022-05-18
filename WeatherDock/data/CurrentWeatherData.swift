//
//  CurrentWeatherData.swift
//  OpenWeather
//
//  Created by Aleksandr Stepanischev on 05/05/2022.
//

import SwiftUI

struct CurrentWeatherData: Codable {
    var coord: Coord
    var weather: [Weather]
    var base: String
    var main: Main
    var visibility: Int
    var wind: Wind
    var clouds: Clouds
    var dt: Double
    var sys: Sys
    var timezone: Int
    var id: Int
    var name: String
    var cod: Int
    
    static func getEmpty() -> CurrentWeatherData {
        return CurrentWeatherData (
            coord: Coord(lon: 0.0, lat: 0.0),
            weather: [Weather(id: 0, main: "No data", description: "No data", icon: "?")],
            base: "?",
            main: Main(temp: 0.0, feels_like: 0.0, temp_min: 0.0, temp_max: 0.0, pressure: 0, humidity: 0),
            visibility: 0,
            wind: Wind(speed: 0.0, deg: 0),
            clouds: Clouds(all: 0),
            dt: 0,
            sys: Sys(type: 0, id: 0, country: "Unknown Country", sunrise: 0, sunset: 0),
            timezone: 0,
            id: 0,
            name: "Unknown City",
            cod: 0)
    }
}

struct Coord: Codable {
    var lon: Double
    var lat: Double
}

struct Weather: Codable {
    var id: Int
    var main: String
    var description: String
    var icon: String
}

struct Main: Codable {
    var temp: Double
    var feels_like: Double
    var temp_min: Double
    var temp_max: Double
    var pressure: Int
    var humidity: Int
}

struct Wind: Codable {
    var speed: Double
    var deg: Int
}

struct Clouds: Codable {
    var all: Int
}

struct Sys: Codable {
    var type: Int?
    var id: Int?
    var country: String
    var sunrise: Double
    var sunset: Double
}
