//
//  SettingsView.swift
//  WeatherDock
//
//  Created by Aleksandr Stepanischev on 09/05/2022.
//

import SwiftUI

struct SettingsView: View {
    private enum Tabs: Hashable {
        case general, donate, about
    }
    var body: some View {
        TabView {
            GeneralSettingsView()
                .tabItem {
                    Label("General", systemImage: "gear")
                }
                .tag(Tabs.general)
//            DonateView()
//                .tabItem {
//                    Label("Donate", systemImage: "heart")
//                }
//                .tag(Tabs.donate)
            AboutSettingsView()
                .tabItem {
                    Label("About", systemImage: "star")
                }
                .tag(Tabs.about)
        }
        .frame(width: 400, height: 400, alignment: .top)
    }
}
