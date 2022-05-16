//
//  AboutSettingsView.swift
//  OpenWeather
//
//  Created by Aleksandr Stepanischev on 09/05/2022.
//

import SwiftUI

struct AboutSettingsView: View {
    var body: some View {
        VStack(alignment: .center){
            HStack {
                Image(systemName: "umbrella").font(.largeTitle)
                Text("Weather Dock").font(.title)
            }
            Text("Application shows weather info at MacOS menu bar.").font(.headline).padding(.vertical, 5)
            Text("Weather Dock application is open sourced. For feature guide and additional information about implementation, please, visit Github page")
                .frame(maxWidth: .infinity, alignment: .leading)
            HStack{
                Image(systemName: "g.circle.fill")
                Text("https://github.com/AlexStepanischev/WeatherDock")
            }.padding(.vertical, 5)
            Text("If you need a support or have any questions, feedback, bug reports or feature requests, please, contact via Telegram chat")
                .frame(maxWidth: .infinity, alignment: .leading)
            HStack{
                Image(systemName: "paperplane.fill")
                Text("https://t.me/weather_dock_app")
            }.padding(.top, 5)
            Spacer()
            Text("Powered with [OpenWeatherAPI](https://openweathermap.org/api)").padding(.top)
            Text("Copyright © 2022 Aleksandr Stepanischev").font(.footnote).foregroundColor(.gray).padding(.top)
        }
    }
}
