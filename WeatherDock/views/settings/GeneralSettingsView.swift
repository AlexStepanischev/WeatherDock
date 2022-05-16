//
//  GeneralSettingsView.swift
//  OpenWeather
//
//  Created by Aleksandr Stepanischev on 09/05/2022.
//

import SwiftUI

struct GeneralSettingsView: View {
    @AppStorage("unitsOfMeasurement") private var unitsOfMeasurement = DefaultSettings.unitsOfMeasurement
    @AppStorage("pressureUnit") private var pressureUnit = DefaultSettings.pressureUnit
    @AppStorage("timeFormat") private var timeFormat = DefaultSettings.timeFormat
    
    var body: some View {
        Form {
            Picker("Units of measurement", selection: $unitsOfMeasurement) {
                Text("Imperial").tag(UnitsOfMeasurement.imperial.rawValue)
                Text("Metric").tag(UnitsOfMeasurement.metric.rawValue)
            }
            .onChange(of: unitsOfMeasurement) {
                tag in WeatherData.shared.getAllData()
            }
            Picker("Pressure unit", selection: $pressureUnit) {
                Text(PressureUnits.inHg.rawValue).tag(PressureUnits.inHg.rawValue)
                Text(PressureUnits.mmHg.rawValue).tag(PressureUnits.mmHg.rawValue)
                Text(PressureUnits.hPa.rawValue).tag(PressureUnits.hPa.rawValue)
            }
            .onChange(of: pressureUnit) {
                tag in WeatherData.shared.refreshView()
            }
            Picker("Time format", selection: $timeFormat) {
                Text("12h").tag(TimeFormat.twelve.rawValue)
                Text("24h").tag(TimeFormat.twentyfour.rawValue)
            }
            .onChange(of: timeFormat) {
                tag in WeatherData.shared.refreshView()
            }
        }
        .padding(20)
    }
}
