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
    var icon = "cloud.sun"
    var temperature = 0
    var temp_unit = "°F"
    var description = "No data"
    var short_desc = "No data"
    var feels_like = 0
    var sunrise = 0.0
    var sunset = 0.0
    var humidity = 0
    var wind_speed = 0
    var wind_unit = "mph"
    var pressure = 0
    var city = "Unknown City"
    
    func getConvertedPressure() -> String{
        return Utils.getPressureValueUnit(hPa: pressure)
    }
    
    func getSunriseFormatted() -> String{
        return Utils.getLongTimefromUnix(dt: sunrise, timezone: timezone)
    }
    
    func getSunsetFormatted() -> String{
        return Utils.getLongTimefromUnix(dt: sunset, timezone: timezone)
    }
}
