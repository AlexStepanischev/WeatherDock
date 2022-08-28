//
//  AirPollutionView.swift
//  WeatherDock
//
//  Created by Aleksandr Stepanischev on 8/28/22.
//

import SwiftUI

struct AirPollutionView: View {
    
    @StateObject var weatherData: WeatherData = WeatherData.shared
    @State var isPopover = false
    
    var body: some View {
        let airPollution = weatherData.airPollutionData
        
        if airPollution.list.count > 0 {
            HStack{
                Image(systemName: Utils.aqi[airPollution.list[0].main.aqi]?.1 ?? "aqi.low").font(Font.system(size: 15, weight: .bold))
                    .help("Air quality")
                Text(Utils.aqi[airPollution.list[0].main.aqi]?.0 ?? "Unknown").font(.headline)
                    .help("Air quality")
                    .padding(.trailing)
            }.popover(isPresented: self.$isPopover, arrowEdge: .trailing) {
                AQPopoverView(components: airPollution.list[0].components)
            }
            .onHover { hover in
                self.isPopover = hover
            }
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

