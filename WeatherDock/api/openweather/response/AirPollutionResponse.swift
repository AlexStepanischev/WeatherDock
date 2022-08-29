//
//  AirPollutionResponse.swift
//  WeatherDock
//
//  Created by Aleksandr Stepanischev on 22/06/2022.
//

import SwiftUI

struct AirPollutionResponse: Codable {
    var coord: Coord
    var list: [Pollution]
    
    static func getEmpty() -> AirPollutionResponse {
        return AirPollutionResponse(
            coord: Coord(lon: 0.0, lat: 0.0),
            list: [
                Pollution(
                    dt: 0.0,
                    main: Aqi(aqi: 0),
                    components: AirComponents()
                )
            ]
        )
    }
}

struct Pollution: Codable {
    var dt: Double
    var main: Aqi
    var components: AirComponents
}

struct Aqi: Codable {
    var aqi: Int
}

struct AirComponents: Codable {
    var co: Double?
    var no: Double?
    var no2: Double?
    var o3: Double?
    var so2: Double?
    var pm2_5: Double?
    var pm10: Double?
    var nh3: Double?
}
