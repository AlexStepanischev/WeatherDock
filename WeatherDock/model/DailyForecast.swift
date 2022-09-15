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
        
        if data.isEmpty || data[0].dt == 0.0 {
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
        return Array<DayData>(data.prefix(upTo: 7))
    }
    
    func getDailyTrimmedToSeven() -> [DayData] {
        var data = day_data
        
        if data.isEmpty || data[0].dt == 0.0 {
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
    var temperature = 0
    var temperature_night = 0
    var description = "No data"
    var short_desc = "No data"
    var feels_like = 0
    var sunrise = 0.0
    var sunset = 0.0
    var humidity = 0
    var wind_speed = 0
    var pressure = 0
    var precipitation = 0
    var weather_condition = 0
    var icon = "cloud.sun"
    
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
    
    func getDayDate(timeone: Int) -> (String, String) {
        return Utils.getDayDate(dt: dt, timezone: timezone)
    }
    
    func getDate() -> String {
        return Utils.getDate(dt: dt, timezone: timezone)
    }
    
    func getIcon() -> String {
        if weather_condition == 0 {
            return icon
        } else {
            return Utils.getIconByConditionId(id: weather_condition)
        }
    }
    
    func getWindUnit() -> String {
        Utils.getSpeedMeasurement()
    }
    
    func getTempUnit() -> String {
        return Utils.getTempMeasurement()
    }
    
    func getConvertedPressure() -> String{
        return Utils.getPressureValueUnit(hPa: pressure)
    }
    
    func getSunriseFormatted(timezone: Int) -> String{
        return Utils.getLongTimefromUnix(dt: sunrise, timezone: timezone)
    }
    
    func getSunsetFormatted(timezone: Int) -> String{
        return Utils.getLongTimefromUnix(dt: sunset, timezone: timezone)
    }
}
