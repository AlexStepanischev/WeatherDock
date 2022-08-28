//
//  CurrentWeatherView.swift
//  WeatherDock
//
//  Created by Aleksandr Stepanischev on 05/05/2022.
//

import SwiftUI

struct CurrentWeatherView: View {
    
    @StateObject var weatherData: WeatherData = WeatherData.shared
    @Binding var updater: Bool

    
    var body: some View {
        
        let currentWeather: CurrentWeather = weatherData.currentWeather
        
        VStack{
            HStack{
                HStack(alignment: .top){
                    Image(systemName: currentWeather.icon).font(Font.system(size: 40, weight: .bold))
                    Text("\(currentWeather.temperature)°\(currentWeather.temp_unit)").font(Font.system(size: 30, weight: .bold))
                        .frame(width: 90)
                }.padding(.trailing)
                VStack(alignment: .leading){
                    Text(currentWeather.description).font(.title2)
                    Text("FEELS LIKE \(currentWeather.feels_like)°\(currentWeather.temp_unit)").font(.footnote)
                }.padding(.trailing).frame(height: 60)
                VStack (alignment: .leading){
                    HStack{
                        Image(systemName: "sunrise").font(Font.system(size: 15))
                            .help("Sunrise")
                        Text(currentWeather.sunrise)
                            .help("Sunrise")
                    }.padding(.bottom, 1)
                    HStack{
                        Image(systemName: "sunset").font(Font.system(size: 15))
                            .help("Sunset")
                        Text(currentWeather.sunset)
                            .help("Sunset")
                    }
                }
            }.padding(.top).padding(.horizontal)
            
            HStack{
                HStack{
                    Image(systemName: "humidity").font(Font.system(size: 15, weight: .bold))
                        .help("Humidity")
                    Text("\(currentWeather.humidity)%").font(.headline)
                        .help("Humidity")
                }.padding(.horizontal)
                HStack{
                    Image(systemName: "wind").font(Font.system(size: 15, weight: .bold))
                        .help("Wind speed")
                    Text("\(currentWeather.wind_speed) \(currentWeather.wind_unit)").font(.headline)
                        .help("Wind speed")
                }.padding(.trailing)
                HStack{
                    Image(systemName: "barometer").font(Font.system(size: 15, weight: .bold))
                        .help("Pressure")
                    Text(currentWeather.getConvertedPressure()).font(.headline)
                        .help("Pressure")
                }.padding(.trailing)
                AirPollutionView()
            }.padding(.top, 1)
        }
    }
}
