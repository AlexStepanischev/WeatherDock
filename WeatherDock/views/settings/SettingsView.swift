//
//  SettingsView.swift
//  WeatherDock
//
//  Created by Aleksandr Stepanischev on 09/05/2022.
//

import SwiftUI

struct SettingsView: View {
    private enum Tabs: Hashable {
        case general, about
    }
    var body: some View {
        TabView {
            GeneralSettingsView()
                .tabItem {
                    Label("General", systemImage: "gear")
                }
                .tag(Tabs.general)
            AboutSettingsView()
                .tabItem {
                    Label("About", systemImage: "star")
                }
                .tag(Tabs.about)
        }
        .frame(width: 400, height: 400, alignment: .top)
    }
}
