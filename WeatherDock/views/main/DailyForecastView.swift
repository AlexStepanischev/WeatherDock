//
//  DailyForecastView.swift
//  WeatherDock
//
//  Created by Aleksandr Stepanischev on 07/05/2022.
//

import SwiftUI

struct DailyForecastView: View {
    
    @StateObject var weatherData: WeatherData = WeatherData.shared    
    @Binding var updater: Bool
    @State var hoverState = false
    @State var hoverID = ""
    var body: some View {
        
        let dailyForecast = weatherData.dailyForecast
        
        HStack(spacing: 25){
            ForEach(dailyForecast.getDaily()){ data in
                let dayDate = data.getDayDate(timeone: dailyForecast.timezone)
                VStack{
                    Text(dayDate.0.uppercased()).font(.headline)
                    Text(dayDate.1).font(.caption).padding(.bottom, 5)
                    Image(systemName: data.getIcon()).font(.title).frame(height: 15)
                    Text("\(data.temperature)°\(data.getTempUnit())").font(.subheadline).bold().padding(.top, 2)
                    HStack(spacing: 1) {
                        Image(systemName: "drop").font(.caption)
                            .help("Probability of precipitation")
                        Text("\(data.precipitation)%").font(.caption)
                            .help("Probability of precipitation")
                    }
                }
                .popover(isPresented: self.makeIsPresented(id: data.id.uuidString), arrowEdge: .bottom) {
                    DailyDetailsPopoverView(data: data, timezone: dailyForecast.timezone)
                }
                .onHover { hover in
                    self.hoverID = data.id.uuidString
                    self.hoverState = hover
                }
            }
        }.padding(.vertical)
    }
    
    func makeIsPresented(id: String) -> Binding<Bool> {
        return .init(get: {
            if self.hoverState {
                return self.hoverID == id
            } else {
                return false
            }
        }, set: { _ in
        })
    }
}

struct DailyDetailsPopoverView: View {
    var data: DayData
    var timezone: Int
    var body: some View {
        VStack{
            Text(data.getDate()).font(.title2).padding(.bottom, 1)
            HStack{
                HStack(alignment: .top){
                    Image(systemName: data.getIcon()).font(Font.system(size: 40, weight: .bold))
                    VStack(alignment: .leading) {
                        Text("\(data.temperature)°\(data.getTempUnit())")
                            .font(Font.system(size: 30, weight: .bold))
                            .frame(width: 90)
                        HStack{
                            Image(systemName: "moon.stars")
                            Text("\(data.temperature_night)°\(data.getTempUnit())")
                        }
                    }.multilineTextAlignment(.leading)
                }.padding(.trailing)
                VStack(alignment: .leading){
                    Text(data.description).font(.title2)
                    if data.feels_like != 888 {
                        Text("FEELS LIKE \(data.feels_like)°\(data.getTempUnit())").font(.footnote)
                    }
                }.padding(.trailing).frame(height: 60)
                VStack (alignment: .leading){
                    HStack{
                        Image(systemName: "sunrise").font(Font.system(size: 15))
                        Text(data.getSunriseFormatted(timezone: timezone))
                    }.padding(.bottom, 1)
                    HStack{
                        Image(systemName: "sunset").font(Font.system(size: 15))
                        Text(data.getSunsetFormatted(timezone: timezone))
                    }
                }
            }
            
            HStack{
                HStack{
                    if data.humidity != 888 {
                        Image(systemName: "humidity").font(Font.system(size: 15, weight: .bold))
                        Text("\(data.humidity)%").font(.headline)
                    }
                }.padding(.trailing)
                HStack{
                    Image(systemName: "wind").font(Font.system(size: 15, weight: .bold))
                    Text("\(data.wind_speed) \(data.getWindUnit())").font(.headline)
                }.padding(.trailing)
                HStack{
                    if data.pressure != 888 {
                        Image(systemName: "barometer").font(Font.system(size: 15, weight: .bold))
                        Text(data.getConvertedPressure()).font(.headline)
                    }
                }.padding(.trailing)
                HStack{
                    Image(systemName: "drop").font(Font.system(size: 15, weight: .bold))
                    Text("\(data.precipitation)%").font(.headline)
                }
            }.padding(.top, 1)
        }
        .frame(width: 450, height: 160)
    }
}
