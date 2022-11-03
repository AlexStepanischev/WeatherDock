//
//  AboutSettingsView.swift
//  WeatherDock
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
            Text("Weather Dock application is open sourced. For feature guide and additional information about implementation, please, visit Github page").padding(.vertical, 5)
                .frame(maxWidth: .infinity, alignment: .leading)
            HStack{
                Image(systemName: "g.circle.fill")
                Text("https://github.com/AlexStepanischev/WeatherDock")
            }.padding(.vertical, 5)
            Text("If you need a support or have any questions, feedback, bug reports or feature requests, please, contact via Telegram or WhatsApp chat")
                .frame(maxWidth: .infinity, alignment: .leading)
            HStack{
                Image(systemName: "paperplane.fill")
                Text("https://t.me/weather_dock_app")
            }.padding(.top, 5)
            HStack{
                Image(systemName: "message.fill")
                Text("https://chat.whatsapp.com/FtHmQLWtE4jBijg1THdgBJ")
            }.padding(.top, 5)
            Spacer()
            HStack {
                Text("Powered with [OpenWeatherAPI](https://openweathermap.org/api)")
                if #available(macOS 13, *){
                    Text("and")
                    AttributionView()
                }
            }.padding(.top)
            Text("Copyright © 2022 Aleksandr Stepanischev").font(.footnote).foregroundColor(.gray).padding(.top)
        }.padding()
    }
}

@available(macOS 13.0, *)
struct AttributionView: View {
    let attributionLink = URL(string: "https://weatherkit.apple.com/legal-attribution.html")
    let attributionLogo = "applelogo"
    var body: some View {
        HStack{
            Image(systemName: attributionLogo)
            Link("Weather", destination: attributionLink!)
        }
    }
        
}
