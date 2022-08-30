//
//  HourlyForecast.swift
//  WeatherDock
//
//  Created by Aleksandr Stepanischev on 8/29/22.
//

import SwiftUI

struct HourlyForecast {
    var hour_data: [HourData]
    
    func getHourlyTrimmed() -> [HourData] {
        var data = hour_data
        
        if data[0].dt == 0.0 {
            return HourData.getEmptyArray()
        }

        while !data.isEmpty && data[0].dt < Date.now.timeIntervalSince1970 {
            data.removeFirst()
        }
        
        if data.isEmpty {
            return HourData.getEmptyArray()
        }
        
        return Array(data.prefix(24))
    }
}

struct HourData: Identifiable {
    var id = UUID()
    
    var dt = 0.0
    var timezone_offset = 0
    var temperature = 0
    var precipitation = 0
    var weather_condition = 0

    func getIcon() -> String {
        return Utils.getIconByTimeConditionId(id: weather_condition, dt: dt)
    }
    
    func getTempUnit() -> String {
        return Utils.getTempMeasurement()
    }
    
    func getTimeFormatted() -> String {
        return Utils.getTimefromUnix(dt: dt, timezone: timezone_offset)
    }
    
    static func getEmptyArray() -> [HourData]{
        return [
            HourData(),
            HourData(),
            HourData(),
            HourData(),
            HourData(),
            HourData(),
            HourData(),
            HourData(),
            HourData(),
            HourData(),
            HourData(),
            HourData()
        ]
    }
}
