//
//  HourlyForecastView.swift
//  WeatherDock
//
//  Created by Aleksandr Stepanischev on 8/29/22.
//

import SwiftUI

struct HourlyForecastView: View {
    
    @StateObject var weatherData: WeatherData = WeatherData.shared
    @Binding var updater: Bool
    
    var body: some View {
        ScrollView(.horizontal){
            HStack(alignment: .top){
                ForEach(weatherData.forecastData.getHourlyTrimmed()){ data in
                    VStack{
                        Text("\(Int(data.temp.rounded()))°\(Utils.getTempMeasurement())").font(.headline)
                        HStack(spacing: 1) {
                            Image(systemName: "drop").font(.caption)
                                .help("Probability of precipitation")
                            Text("\(Int(round(data.pop*100)))%").font(.caption)
                                .help("Probability of precipitation")
                        }
                        Image(systemName: Utils.getIconByTimeConditionId(id: data.weather[0].id, dt: data.dt)).font(.title).frame(height: 15)
                        Text(Utils.getTimefromUnix(dt: data.dt, timezone: weatherData.forecastData.timezone_offset)).font(.subheadline).padding(.top, 2)
                    }.padding(.leading)
                }
            }.padding(.bottom).padding(.trailing)
        }.padding(.top)
         .transition(.move(edge: .bottom))
    }
}
