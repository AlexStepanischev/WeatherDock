//
//  DefaultSettings.swift
//  WeatherDock
//
//  Created by Aleksandr Stepanischev on 10/05/2022.
//

import SwiftUI

struct DefaultSettings {
    static let unitsOfMeasurement = UnitsOfMeasurement.imperial.rawValue
    static let pressureUnit = PressureUnits.inHg.rawValue
    static let timeFormat = TimeFormat.twelve.rawValue
    static let getDataBy = GetDataBy.location.rawValue
    static let showTemperature = true
    static let showDescription = false
    static let showCityName = false
}

enum UnitsOfMeasurement: String, Identifiable{
    case metric, imperial
    var id: String { self.rawValue }
}

enum PressureUnits: String, Identifiable {
    case hPa, mmHg, inHg
    var id: String { self.rawValue }
}

enum TimeFormat: String, Identifiable {
    case twelve, twentyfour
    var id: String { self.rawValue }
}

enum GetDataBy: String, Identifiable {
    case location, city
    var id: String { self.rawValue }
}
