//
//  DonateView.swift
//  WeatherDock
//
//  Created by Aleksandr Stepanischev on 9/16/22.
//

import SwiftUI

struct DonateView: View {
    var body: some View {
        VStack{
            Text("Coffee time!").font(.title).padding(.top)
            Text("Dear user, if you like this application and want to express gratitude or support futher development, you know what to do 😉").padding()
            Link(destination: URL(string: "https://www.buymeacoffee.com/astep")!, label: {
                Image("buymeacoffee")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300)
            })
            Text("Thank you!").padding()
        }
    }
}
