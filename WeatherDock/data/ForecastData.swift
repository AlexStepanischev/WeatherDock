//
//  ForecastData.swift
//  OpenWeather
//
//  Created by Aleksandr Stepanischev on 07/05/2022.
//

import SwiftUI

struct ForecastData: Codable {
    var lat: Double
    var lon: Double
    var timezone: String
    var timezone_offset: Int
    var hourly: [Hourly]
    var daily: [Daily]
    
    func getHourlyTrimmed() -> [Hourly] {
        var data = hourly
        
        if data[0].dt == 0.0 {
            return Hourly.getEmptyArray()
        }

        while data[0].dt < Date.now.timeIntervalSince1970 {
            data.removeFirst()
        }
        
        let result = Array(data.prefix(24))
        return result
    }
    
    func getDailyTrimmed() -> [Daily] {
        var data = daily
        
        if data[0].dt == 0.0 {
            return Daily.getEmptyArray()
        }
        
        var trimmer = true
        
        while trimmer {
            
            let now = Date()
            let nowWithOffset = now.timeIntervalSince1970 + Double(timezone_offset)
            let nowDate = Date(timeIntervalSince1970: nowWithOffset)
            
            let dataDate = Date(timeIntervalSince1970: data[0].dt)

            var calendar = Calendar(identifier: .gregorian)
            calendar.timeZone = TimeZone(identifier: "UTC")!
            let order = calendar.compare(nowDate, to: dataDate, toGranularity: .day)
            
            switch order {
            case .orderedDescending:
                data.removeFirst()
            case .orderedAscending:
                trimmer = false
            case .orderedSame:
                data.removeFirst()
                trimmer = false
            }
            
        }
        
        return data
    }
        
    static func getEmpty() -> ForecastData {
        return ForecastData(
            lat: 0.0,
            lon: 0.0,
            timezone: "Unknown",
            timezone_offset: 0,
            hourly: Hourly.getEmptyArray(),
            daily: Daily.getEmptyArray()
        )
    }
}

struct Hourly: Codable, Identifiable {
    var id: Double { self.dt }
    
    var dt: Double
    var temp: Double
    var feels_like: Double
    var pressure: Int
    var humidity: Int
    var dew_point: Double
    var uvi: Double
    var clouds: Int
    var visibility: Int
    var wind_speed: Double
    var wind_deg: Int
    var wind_gust: Double
    var weather: [Weather]
    var pop: Double
    
    static func getEmpty() -> Hourly {
        return Hourly(
            dt: 0.0,
            temp: 0.0,
            feels_like: 0.0,
            pressure: 0,
            humidity: 0,
            dew_point: 0.0,
            uvi: 0.0,
            clouds: 0,
            visibility: 0,
            wind_speed: 0.0,
            wind_deg: 0,
            wind_gust: 0.0,
            weather: [
                Weather(
                    id: 0,
                    main: "Unknown",
                    description: "Unknown",
                    icon: "0")
            ],
            pop: 0.0)
    }
    
    static func getEmptyArray() -> [Hourly] {
        return [
            getEmpty(),
            getEmpty(),
            getEmpty(),
            getEmpty(),
            getEmpty(),
            getEmpty(),
            getEmpty(),
            getEmpty(),
            getEmpty(),
            getEmpty(),
            getEmpty(),
            getEmpty()
        ]
    }
    
}

struct Daily: Codable, Identifiable {
    var id: Double { self.dt }
    
    var dt: Double
    var sunrise: Double
    var sunset: Double
    var moonrise: Int
    var moonset: Int
    var moon_phase: Double
    var temp: Temp
    var feels_like: FeelsLike
    var pressure: Int
    var humidity: Int
    var dew_point: Double
    var wind_speed: Double
    var wind_deg: Int
    var wind_gust: Double
    var weather: [Weather]
    var clouds: Int
    var pop: Double
    var uvi: Double
    
    static func getEmpty() -> Daily {
        return Daily(
            dt: 0.0,
            sunrise: 0.0,
            sunset: 0.0,
            moonrise: 0,
            moonset: 0,
            moon_phase: 0.0,
            temp: Temp(day: 0.0, min: 0.0, max: 0.0, night: 0.0, eve: 0.0, morn: 0.0),
            feels_like: FeelsLike(day: 0.0, night: 0.0, eve: 0.0, morn: 0.0),
            pressure: 0,
            humidity: 0,
            dew_point: 0.0,
            wind_speed: 0.0,
            wind_deg: 0,
            wind_gust: 0,
            weather: [
                Weather(
                    id: 0,
                    main: "Unknown",
                    description: "Unknown",
                    icon: "0")
            ],
            clouds: 0,
            pop: 0.0,
            uvi: 0.0)
    }
    static func getEmptyArray() -> [Daily] {
        return [
            getEmpty(),
            getEmpty(),
            getEmpty(),
            getEmpty(),
            getEmpty(),
            getEmpty(),
            getEmpty()
        ]
    }
}

struct Temp: Codable {
    var day: Double
    var min: Double
    var max: Double
    var night: Double
    var eve: Double
    var morn: Double
}

struct FeelsLike: Codable {
    var day: Double
    var night: Double
    var eve: Double
    var morn: Double
}
