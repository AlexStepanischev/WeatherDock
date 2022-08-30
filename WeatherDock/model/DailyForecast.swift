//
//  DailyForecast.swift
//  WeatherDock
//
//  Created by Aleksandr Stepanischev on 8/29/22.
//

import SwiftUI

struct DailyForecast {
    var day_data: [DayData]
    var timezone = 0
    
    func getDaily() -> [DayData]{
        if getDailyTrimmed().count < 7 {
            WeatherData.shared.getAllData()
            return getDailyTrimmedToSeven()
        }
        return getDailyTrimmed()
    }
    
    func getDailyTrimmed() -> [DayData] {
        var data = day_data
        
        if data[0].dt == 0.0 {
            return DayData.getEmptyArray()
        }
        
        var trimmer = true
        
        while trimmer {
            
            let now = Date()
            let nowWithOffset = now.timeIntervalSince1970 + Double(timezone)
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
    
    func getDailyTrimmedToSeven() -> [DayData] {
        var data = day_data
        
        if data[0].dt == 0.0 {
            return DayData.getEmptyArray()
        }
        
        while data.count < 7 {
            data.removeFirst()
        }
        
        return data
    }    
}

struct DayData: Identifiable {
    var id = UUID()
    
    var dt = 0.0
    var timezone_offset = 0
    var dayDate = ("THU", "Jan 1")
    var date = "Thursday, January 1, 1970"
    var icon = "cloud.sun"
    var temperature = 0
    var temperature_night = 0
    var temp_unit = Utils.getTempMeasurement()
    var description = "No data"
    var short_desc = "No data"
    var feels_like = 0
    var sunrise = 0.0
    var sunset = 0.0
    var humidity = 0
    var wind_speed = 0
    var wind_unit = Utils.getSpeedMeasurement()
    var pressure = 0
    var precipitation = 0
    var weather_condition = 0
    
    static func getEmptyArray() -> [DayData]{
        return [
            DayData(),
            DayData(),
            DayData(),
            DayData(),
            DayData(),
            DayData(),
            DayData()
        ]
    }
    
    func getConvertedPressure() -> String{
        return Utils.getPressureValueUnit(hPa: pressure)
    }
    
    func getSunriseFormatted() -> String{
        return Utils.getLongTimefromUnix(dt: sunrise, timezone: timezone_offset)
    }
    
    func getSunsetFormatted() -> String{
        return Utils.getLongTimefromUnix(dt: sunset, timezone: timezone_offset)
    }
}
