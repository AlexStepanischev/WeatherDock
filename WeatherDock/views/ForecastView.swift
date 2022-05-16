//
//  ForecastView.swift
//  OpenWeather
//
//  Created by Aleksandr Stepanischev on 07/05/2022.
//

import SwiftUI

struct ForecastView: View {
    var forecastData: ForecastData
    @Binding var updater: Bool
    
    var body: some View {
        ScrollView(.horizontal){
            HStack(alignment: .top){
                ForEach(forecastData.getHourlyTrimmed()){ data in
                    VStack{
                        Text("\(Int(data.temp.rounded()))°\(Utils.getTempMeasurement())").font(.headline)
                        Image(systemName: Utils.getIconByTimeConditionId(id: data.weather[0].id, dt: data.dt)).font(.title).frame(height: 15)
                        Text(Utils.getTimefromUnix(dt: data.dt, timezone: forecastData.timezone_offset)).font(.subheadline).padding(.top, 2)
                    }.padding(.leading)
                }
            }.padding(.bottom).padding(.trailing)
        }.padding(.top)
         .transition(.move(edge: .bottom))
        
        Divider()
        
        HStack(spacing: 25){
            ForEach(forecastData.getDailyTrimmed()){ data in
                VStack{
                    let dayDate = Utils.getDayDate(dt: data.dt, timezone: forecastData.timezone_offset)
                    Text(dayDate.0.uppercased()).font(.headline)
                    Text(dayDate.1).font(.caption).padding(.bottom, 5)
                    Image(systemName: Utils.getIconByConditionId(id: data.weather[0].id)).font(.title).frame(height: 15)
                    Text("\(Int(data.temp.max.rounded()))°\(Utils.getTempMeasurement())").font(.subheadline).bold().padding(.top, 2)
                    Text("\(Int(data.temp.night.rounded()))°\(Utils.getTempMeasurement())").font(.subheadline)
                }
            }
        }.padding(.top)
    }
}
