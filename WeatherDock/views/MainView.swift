//
//  ContentView.swift
//  WeatherDock
//
//  Created by Aleksandr Stepanischev on 03/05/2022.
//

import SwiftUI

struct MainView: View {
    
    @StateObject var data: WeatherData = WeatherData.shared
    @FocusState private var focusState: Bool
    @State private var disabled: Bool = true
    @AppStorage("city") private var city = ""    
    @AppStorage("getDataBy") private var getDataBy = DefaultSettings.getDataBy
    
    var body: some View {
        VStack {
            HStack{
                Button {
                    data.refreshCurrentWeatherData()
                } label: {
                    Image(systemName: "arrow.clockwise")
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.leading)
                Spacer()
                Text(Utils.getDate(dt: data.currentWeatherData.dt, timezone: data.currentWeatherData.timezone)).font(.title2).padding(.bottom, 1)
                Spacer()
                Button {
                    NSApp.activate(ignoringOtherApps: true)
                    NSApp.sendAction(Selector(("showPreferencesWindow:")), to: nil, from: nil)

                } label: {
                    Image(systemName: "gearshape")
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.trailing)
            }.padding(.top)
            HStack(){
                Button {
                    getDataBy = GetDataBy.location.rawValue
                    data.getAllData()
                } label: {
                    Image(systemName: "location")
                }
                .buttonStyle(PlainButtonStyle())

                TextField("City Name", text: Binding(
                        get: { return self.city },
                        set: { self.city = $0 }
                        ), onCommit: {
                            DispatchQueue.main.async {
                                NSApp.keyWindow?.makeFirstResponder(nil)
                            }
                        }
                ).textFieldStyle(PlainTextFieldStyle())
                .onSubmit {
                    WeatherData.shared.city = city
                    getDataBy = GetDataBy.city.rawValue
                    WeatherData.shared.getAllData()
                }
                .focused($focusState, equals: false)
                .disabled(disabled)
                .onAppear {
                        DispatchQueue.main.async {
                            disabled = false
                            NSApp.keyWindow?.makeFirstResponder(nil)
                        }
                }
                .frame(width: 375)
                .multilineTextAlignment(.center)
   
            }.padding(.top, 5)
            
            CurrentWeatherView(data: data.currentWeatherData, aqi: data.airPollutionData, updater: $data.updater)
            
            Divider()

            ForecastView(forecastData: data.forecastData, daily: data.forecastData.getDaily(), updater: $data.updater)
        }
        .frame(width: 430)
        .onTapGesture {
            DispatchQueue.main.async {
                NSApp.keyWindow?.makeFirstResponder(nil)
            }
            focusState = false
            city = data.currentWeatherData.name
        }
    }
}
