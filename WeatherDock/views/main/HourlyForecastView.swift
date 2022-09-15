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
        
        let hourlyForecast = weatherData.hourlyForecast
        
        ScrollView(.horizontal){
            HStack(alignment: .top){
                ForEach(hourlyForecast.getHourlyTrimmed()){ data in
                    VStack{
                        Text("\(data.temperature)°\(data.getTempUnit())").font(.headline)
                        HStack(spacing: 1) {
                            Image(systemName: "drop").font(.caption)
                                .help("Probability of precipitation")
                            Text("\(data.precipitation)%").font(.caption)
                                .help("Probability of precipitation")
                        }
                        Image(systemName: data.icon).font(.title).frame(height: 15)
                        Text(data.getTimeFormatted(timezone: hourlyForecast.timezone_offset)).font(.subheadline).padding(.top, 2)
                    }.padding(.leading)
                }
            }.padding(.bottom).padding(.trailing)
        }.padding(.top)
         .transition(.move(edge: .bottom))        
    }
}
