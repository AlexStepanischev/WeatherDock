//
//  HeaderView.swift
//  WeatherDock
//
//  Created by Aleksandr Stepanischev on 8/27/22.
//

import SwiftUI

struct HeaderView: View {
    
    @StateObject var data: WeatherData = WeatherData.shared
    @Binding var updater: Bool
    
    var body: some View {
        HStack{
            Button {
                data.refreshCurrentWeatherData()
            } label: {
                Image(systemName: "arrow.clockwise")
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.leading)
            Spacer()
            Text(Utils.getDate(dt: data.currentWeatherData.dt, timezone: data.currentWeatherData.timezone)).font(.title2).padding(.bottom, 1)
            Spacer()
            Button {
                NSApp.activate(ignoringOtherApps: true)
                if #available(macOS 13, *) {
                    NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
                } else {
                    NSApp.sendAction(Selector(("showPreferencesWindow:")), to: nil, from: nil)
                }
            } label: {
                Image(systemName: "gearshape")
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.trailing)
        }.padding(.top)
    }
}
