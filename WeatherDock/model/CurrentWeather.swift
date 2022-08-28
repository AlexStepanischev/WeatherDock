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
    var feels_like = 0
    var sunrise = "00:00"
    var sunset = "00:00"
    var humidity = 0
    var wind_speed = 0
    var wind_unit = "mph"
    var pressure = 0
    
    func getConvertedPressure() -> String{
        return Utils.getPressureValueUnit(hPa: pressure)
    }
}
