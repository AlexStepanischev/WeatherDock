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
        
        let airPollution = weatherData.airPollution
        
        HStack{
            Image(systemName: airPollution.aqi_icon).font(Font.system(size: 15, weight: .bold))
                .help("Air quality")
            Text(airPollution.aqi_text).font(.headline)
                .help("Air quality")
                .padding(.trailing)
        }.popover(isPresented: self.$isPopover, arrowEdge: .trailing) {
            AQPopoverView(pollutants: airPollution.pollutants)
        }
        .onHover { hover in
            self.isPopover = hover
        }
    }
}

struct AQPopoverView: View {
    var pollutants: Pollutants
    var body: some View {
        VStack {
            Text("Pollutants").font(.title3).bold()
            Text("μg/m").font(.subheadline).italic() + Text("3").font(.system(size: 7.0)).italic().baselineOffset(5.0)
            VStack(alignment: .leading){
                HStack{
                    CardView(label: "PM2.5", value: pollutants.pm2_5)
                    CardView(label: "PM10", value: pollutants.pm10)
                }
                HStack{
                    CardView(label: "CO", value: pollutants.co)
                    CardView(label: "O3", value: pollutants.o3)
                }
                HStack{
                    CardView(label: "NO", value: pollutants.no)
                    CardView(label: "NO2", value: pollutants.no2)
                }
                HStack{
                    CardView(label: "SO2", value: pollutants.so2)
                    CardView(label: "NH3", value: pollutants.nh3)
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

