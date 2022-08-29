//
//  AirPollution.swift
//  WeatherDock
//
//  Created by Aleksandr Stepanischev on 8/29/22.
//

import SwiftUI

struct AirPollution {
    var aqi = 0
    var aqi_icon = "aqi.low"
    var aqi_text = "Unknown"
    var pollutants = Pollutants()
}

struct Pollutants {
    var co = "N/A"
    var no = "N/A"
    var no2 = "N/A"
    var o3 = "N/A"
    var so2 = "N/A"
    var pm2_5 = "N/A"
    var pm10 = "N/A"
    var nh3 = "N/A"
}
