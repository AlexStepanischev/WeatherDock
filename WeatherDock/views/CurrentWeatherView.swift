//
//  CurrentWeatherView.swift
//  OpenWeather
//
//  Created by Aleksandr Stepanischev on 05/05/2022.
//

import SwiftUI

struct CurrentWeatherView: View {
    var data: CurrentWeatherData
    var aqi: AirPollutionData
    @Binding var updater: Bool
    @State var isPopover = false
    
    var body: some View {
        VStack{
            HStack{
                HStack(alignment: .top){
                    Image(systemName: Utils.getIconByTimeConditionId(id: data.weather[0].id, dt: data.dt)).font(Font.system(size: 40, weight: .bold))
                    Text("\(Int(data.main.temp.rounded()))°\(Utils.getTempMeasurement())").font(Font.system(size: 30, weight: .bold))
                        .frame(width: 90)
                }.padding(.trailing)
                VStack(alignment: .leading){
                    Text(data.weather[0].description.firstCapitalized).font(.title2)
                    Text("FEELS LIKE \(Int(data.main.feels_like.rounded()))°\(Utils.getTempMeasurement())").font(.footnote)
                }.padding(.trailing).frame(height: 60)
                VStack (alignment: .leading){
                    HStack{
                        Image(systemName: "sunrise").font(Font.system(size: 15))
                            .help("Sunrise")
                        Text(Utils.getLongTimefromUnix(dt: data.sys.sunrise, timezone: data.timezone))
                            .help("Sunrise")
                    }.padding(.bottom, 1)
                    HStack{
                        Image(systemName: "sunset").font(Font.system(size: 15))
                            .help("Sunset")
                        Text(Utils.getLongTimefromUnix(dt: data.sys.sunset, timezone: data.timezone))
                            .help("Sunset")
                    }
                }
            }.padding(.top).padding(.horizontal)
            
            HStack{
                HStack{
                    Image(systemName: "humidity").font(Font.system(size: 15, weight: .bold))
                        .help("Humidity")
                    Text("\(data.main.humidity)%").font(.headline)
                        .help("Humidity")
                }.padding(.horizontal)
                HStack{
                    Image(systemName: "wind").font(Font.system(size: 15, weight: .bold))
                        .help("Wind speed")
                    Text("\(Int(data.wind.speed.rounded())) \(Utils.getSpeedMeasurement())").font(.headline)
                        .help("Wind speed")
                }.padding(.trailing)
                HStack{
                    Image(systemName: "barometer").font(Font.system(size: 15, weight: .bold))
                        .help("Pressure")
                    Text(Utils.getPressureValueUnit(hPa: data.main.pressure)).font(.headline)
                        .help("Pressure")
                }.padding(.trailing)
                if aqi.list.count > 0 {
                    HStack{
                        Image(systemName: Utils.aqi[aqi.list[0].main.aqi]?.1 ?? "aqi.low").font(Font.system(size: 15, weight: .bold))
                            .help("Air quality")
                        Text(Utils.aqi[aqi.list[0].main.aqi]?.0 ?? "Unknown").font(.headline)
                            .help("Air quality")
                            .padding(.trailing)
                    }.popover(isPresented: self.$isPopover, arrowEdge: .trailing) {
                        AQPopoverView(components: aqi.list[0].components)
                    }
                    .onHover { hover in
                        self.isPopover = hover
                    }
                }
            }.padding(.top, 1)
        }
    }
}

struct AQPopoverView: View {
    var components: AirComponents
    var body: some View {
        VStack {
            Text("Pollutants").font(.title3).bold()
            Text("μg/m").font(.subheadline).italic() + Text("3").font(.system(size: 7.0)).italic().baselineOffset(5.0)
            VStack(alignment: .leading){
                HStack{
                    CardView(label: "PM2.5", value: String(format: "%.1f", components.pm2_5 ?? 0.0))
                    CardView(label: "PM10", value: String(format: "%.1f", components.pm10 ?? 0.0))
                }
                HStack{
                    CardView(label: "CO", value: String(format: "%.1f", components.co ?? 0.0))
                    CardView(label: "O3", value: String(format: "%.1f", components.o3 ?? 0.0))
                }
                HStack{
                    CardView(label: "NO", value: String(format: "%.1f", components.no ?? 0.0))
                    CardView(label: "NO2", value: String(format: "%.1f", components.no2 ?? 0.0))
                }
                HStack{
                    CardView(label: "SO2", value: String(format: "%.1f", components.so2 ?? 0.0))
                    CardView(label: "NH3", value: String(format: "%.1f", components.nh3 ?? 0.0))
                }
            }.padding(.top, 1)
        }.padding()
    }
}

struct CardView: View {
    var label: String
    var value: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .stroke(lineWidth: 1)

            VStack {
                Text(label).font(.headline)
                Text(value)
            }.padding(5)
            .multilineTextAlignment(.center)
        }.frame(width: 60)
    }
}
