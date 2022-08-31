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
    
    var body: some View {
        VStack {
            
            //Header view with date, refresh and setting buttons
            HeaderView(updater: $data.updater)
            
            //Location and city name line, should be in Main view due to some global focusing logic
            HStack(){
                Button {
                    data.getDataBy = GetDataBy.location.rawValue
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
                    data.city = city
                    data.getDataBy = GetDataBy.city.rawValue
                    data.getAllData()
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
            
            //Current weather view
            CurrentWeatherView(updater: $data.updater)
            
            Divider()
            
            //Hourly forecast view
            HourlyForecastView(updater: $data.updater)
            
            Divider()

            //Daily forecast view
            DailyForecastView(updater: $data.updater)
        }
        .frame(width: 430)
        .onTapGesture {
            DispatchQueue.main.async {
                NSApp.keyWindow?.makeFirstResponder(nil)
            }
            focusState = false
            city = data.currentWeather.city
        }
    }
}
