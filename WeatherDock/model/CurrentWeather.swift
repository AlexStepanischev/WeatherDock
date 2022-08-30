//
//  CurrentWeather.swift
//  WeatherDock
//
//  Created by Aleksandr Stepanischev on 8/27/22.
//

import SwiftUI

struct CurrentWeather {
    var dt = 0.0
    var timezone = 0
    var weather_condition = 0
    var temperature = 0
    var description = "No data"
    var short_desc = "No data"
    var feels_like = 0
    var sunrise = 0.0
    var sunset = 0.0
    var humidity = 0
    var wind_speed = 0
    var pressure = 0
    var city = "Unknown City"
    
    func getIcon() -> String {
        return Utils.getIconByTimeConditionId(id: weather_condition, dt: dt)
    }
    
    func getWindUnit() -> String {
        Utils.getSpeedMeasurement()
    }
    
    func getTempUnit() -> String {
        return Utils.getTempMeasurement()
    }
    
    func getDate() -> String {
        return Utils.getDate(dt: dt, timezone: timezone)
    }
    
    func getConvertedPressure() -> String {
        return Utils.getPressureValueUnit(hPa: pressure)
    }
    
    func getSunriseFormatted() -> String {
        return Utils.getLongTimefromUnix(dt: sunrise, timezone: timezone)
    }
    
    func getSunsetFormatted() -> String {
        return Utils.getLongTimefromUnix(dt: sunset, timezone: timezone)
    }
}
