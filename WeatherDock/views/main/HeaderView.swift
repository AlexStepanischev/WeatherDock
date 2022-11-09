//
//  HeaderView.swift
//  WeatherDock
//
//  Created by Aleksandr Stepanischev on 8/27/22.
//

import SwiftUI

struct HeaderView: View {
    
    @StateObject var weatherData: WeatherData = WeatherData.shared
    @Binding var updater: Bool
    
    var body: some View {
        
        let currentWeather = weatherData.currentWeather
        
        HStack{
            Button {
                weatherData.refreshCurrentWeatherData()
            } label: {
                Image(systemName: "arrow.clockwise")
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.leading)
            Spacer()
            Text(currentWeather.getDate()).font(.title2).padding(.bottom, 1)
            Spacer()
            Menu{
                Button {
                    NSApplication.shared.terminate(self)
                } label: {
                    Text("Quit")
                }
                .buttonStyle(PlainButtonStyle())
            } label: {
                Image(systemName: "xmark")
            }
            .frame(width: 13)
            .menuStyle(.borderlessButton)
            .menuIndicator(.hidden)
            .padding(.trailing)

        }.padding(.top)
    }
}
