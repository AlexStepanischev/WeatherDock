//
//  ForecastView.swift
//  OpenWeather
//
//  Created by Aleksandr Stepanischev on 07/05/2022.
//

import SwiftUI

struct ForecastView: View {
    var forecastData: ForecastData
    var daily: [Daily]
    @Binding var updater: Bool
    @State var hoverState = false
    @State var hoverID = ""
    var body: some View {
        ScrollView(.horizontal){
            HStack(alignment: .top){
                ForEach(forecastData.getHourlyTrimmed()){ data in
                    VStack{
                        Text("\(Int(data.temp.rounded()))°\(Utils.getTempMeasurement())").font(.headline)
                        HStack(spacing: 1) {
                            Image(systemName: "drop").font(.caption)
                                .help("Probability of precipitation")
                            Text("\(Int(round(data.pop*100)))%").font(.caption)
                                .help("Probability of precipitation")
                        }
                        Image(systemName: Utils.getIconByTimeConditionId(id: data.weather[0].id, dt: data.dt)).font(.title).frame(height: 15)
                        Text(Utils.getTimefromUnix(dt: data.dt, timezone: forecastData.timezone_offset)).font(.subheadline).padding(.top, 2)
                    }.padding(.leading)
                }
            }.padding(.bottom).padding(.trailing)
        }.padding(.top)
         .transition(.move(edge: .bottom))
        
        Divider()
        
        HStack(spacing: 25){
            ForEach(daily){ data in
                let dayDate = Utils.getDayDate(dt: data.dt, timezone: forecastData.timezone_offset)
                VStack{
                    Text(dayDate.0.uppercased()).font(.headline)
                    Text(dayDate.1).font(.caption).padding(.bottom, 5)
                    Image(systemName: Utils.getIconByConditionId(id: data.weather[0].id)).font(.title).frame(height: 15)
                    Text("\(Int(data.temp.max.rounded()))°\(Utils.getTempMeasurement())").font(.subheadline).bold().padding(.top, 2)
                    HStack(spacing: 1) {
                        Image(systemName: "drop").font(.caption)
                            .help("Probability of precipitation")
                        Text("\(Int(round(data.pop*100)))%").font(.caption)
                            .help("Probability of precipitation")
                    }
                }
                .popover(isPresented: self.makeIsPresented(id: dayDate.1), arrowEdge: .bottom) {
                    DailyDetailsPopoverView(id: dayDate.1, data: data, timezone: forecastData.timezone_offset)
                }
                .onHover { hover in
                    self.hoverID = dayDate.1
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
    var id: String
    var data: Daily
    var timezone: Int
    var body: some View {
        VStack{
            Text(Utils.getDate(dt: data.dt, timezone: timezone)).font(.title2).padding(.bottom, 1)
            HStack{
                HStack(alignment: .top){
                    Image(systemName: Utils.getIconByConditionId(id: data.weather[0].id)).font(Font.system(size: 40, weight: .bold))
                    VStack(alignment: .leading) {
                        Text("\(Int(data.temp.max.rounded()))°\(Utils.getTempMeasurement())")
                            .font(Font.system(size: 30, weight: .bold))
                            .frame(width: 90)
                        HStack{
                            Image(systemName: "moon.stars")
                            Text("\(Int(data.temp.night.rounded()))°\(Utils.getTempMeasurement())")
                        }
                    }.multilineTextAlignment(.leading)
                }.padding(.trailing)
                VStack(alignment: .leading){
                    Text(data.weather[0].description.firstCapitalized).font(.title2)
                    Text("FEELS LIKE \(Int(data.feels_like.day.rounded()))°\(Utils.getTempMeasurement())").font(.footnote)
                }.padding(.trailing).frame(height: 60)
                VStack (alignment: .leading){
                    HStack{
                        Image(systemName: "sunrise").font(Font.system(size: 15))
                        Text(Utils.getLongTimefromUnix(dt: data.sunrise, timezone: timezone))
                    }.padding(.bottom, 1)
                    HStack{
                        Image(systemName: "sunset").font(Font.system(size: 15))
                        Text(Utils.getLongTimefromUnix(dt: data.sunset, timezone: timezone))
                    }
                }
            }
            
            HStack{
                HStack{
                    Image(systemName: "humidity").font(Font.system(size: 15, weight: .bold))
                    Text("\(data.humidity)%").font(.headline)
                }.padding(.trailing)
                HStack{
                    Image(systemName: "wind").font(Font.system(size: 15, weight: .bold))
                    Text("\(Int(data.wind_speed.rounded())) \(Utils.getSpeedMeasurement())").font(.headline)
                }.padding(.trailing)
                HStack{
                    Image(systemName: "barometer").font(Font.system(size: 15, weight: .bold))
                    Text(Utils.getPressureValueUnit(hPa: data.pressure)).font(.headline)
                }.padding(.trailing)
                HStack{
                    Image(systemName: "drop").font(Font.system(size: 15, weight: .bold))
                    Text("\(Int(round(data.pop*100)))%").font(.headline)
                }
            }.padding(.top, 1)
        }
        .frame(width: 450, height: 160)
    }
}
