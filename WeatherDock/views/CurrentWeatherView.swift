//
//  CurrentWeatherView.swift
//  OpenWeather
//
//  Created by Aleksandr Stepanischev on 05/05/2022.
//

import SwiftUI

struct CurrentWeatherView: View {
    var data: CurrentWeatherData
    @Binding var updater: Bool
    
    var body: some View {
        VStack{
            HStack{
                HStack(alignment: .top){
                    Image(systemName: Utils.getIconByTimeConditionId(id: data.weather[0].id, dt: data.dt)).font(Font.system(size: 40, weight: .bold))
                    Text("\(Int(data.main.temp.rounded()))°\(Utils.getTempMeasurement())").font(Font.system(size: 30, weight: .bold))
                }.padding(.trailing)
                VStack(alignment: .leading){
                    Text(data.weather[0].description.firstCapitalized).font(.title2)
                    Text("FEELS LIKE \(Int(data.main.feels_like.rounded()))°\(Utils.getTempMeasurement())").font(.footnote)
                }.padding(.trailing)
                VStack (alignment: .leading){
                    HStack{
                        Image(systemName: "sunrise").font(Font.system(size: 15))
                        Text(Utils.getLongTimefromUnix(dt: data.sys.sunrise, timezone: data.timezone))
                    }.padding(.bottom, 1)
                    HStack{
                        Image(systemName: "sunset").font(Font.system(size: 15))
                        Text(Utils.getLongTimefromUnix(dt: data.sys.sunset, timezone: data.timezone))
                    }
                }
            }.padding(.top)
            
            HStack{
                HStack{
                    Image(systemName: "humidity").font(Font.system(size: 15, weight: .bold))
                    Text("\(data.main.humidity)%").font(.headline)
                }.padding(.trailing)
                HStack{
                    Image(systemName: "wind").font(Font.system(size: 15, weight: .bold))
                    Text("\(Int(data.wind.speed.rounded())) \(Utils.getSpeedMeasurement())").font(.headline)
                }.padding(.trailing)
                HStack{
                    Image(systemName: "barometer").font(Font.system(size: 15, weight: .bold))
                    Text(Utils.getPressureValueUnit(hPa: data.main.pressure)).font(.headline)
                }.padding(.trailing)
            }.padding(.top, 1)
        }
    }
}
