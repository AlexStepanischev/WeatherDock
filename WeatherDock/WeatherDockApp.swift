//
//  OpenWeatherApp.swift
//  OpenWeather
//
//  Created by Aleksandr Stepanischev on 03/05/2022.
//

import SwiftUI

@main
struct WeatherDockApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        Settings {
            SettingsView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate{
    static var statusItem: NSStatusItem?
    var popOver = NSPopover()
    
    let weatherData = WeatherData.shared
    
    @AppStorage("showTemperature") private static var showTemperature = DefaultSettings.showTemperature
    @AppStorage("showDescription") private static var showDescription = DefaultSettings.showDescription
    @AppStorage("showCityName") private static var showCityName = DefaultSettings.showCityName
    
    func applicationDidFinishLaunching(_ notification: Notification) {

        WeatherData.shared.getAllData()
        
        let menuView = ContentView(data: self.weatherData)
        
        popOver.behavior = .transient
        popOver.animates = true
        
        popOver.contentViewController = NSViewController()
        popOver.contentViewController?.view = NSHostingView(rootView: menuView)
        
        AppDelegate.statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let menuButton = AppDelegate.statusItem?.button {
            AppDelegate.configureMenuButton(menuButton: menuButton, title: "--°\(Utils.getTempMeasurement())",
                                            systemSymbolName: Utils.getIconByTimeConditionId(id: weatherData.currentWeatherData.weather[0].id,
                                                                                         dt: weatherData.currentWeatherData.dt))
            menuButton.action = #selector(menuButtonToggle)
        }
    }
    
    static func configureMenuButton(menuButton: NSStatusBarButton, title: String, systemSymbolName: String){
        menuButton.image = NSImage(systemSymbolName: systemSymbolName , accessibilityDescription: nil)
        let config = NSImage.SymbolConfiguration(textStyle: .title2)
        menuButton.image = menuButton.image?.withSymbolConfiguration(config)
        menuButton.imagePosition = NSControl.ImagePosition.imageLeft
        
        menuButton.title = title
    }
    
    static func updateMenuButton(currentWeatherData: CurrentWeatherData){
        if let menuButton = AppDelegate.statusItem?.button {
            var title = ""
            
            if showTemperature {
                title += "\(Int(currentWeatherData.main.temp.rounded()))°\(Utils.getTempMeasurement())"
            }
            
            if showDescription && currentWeatherData.weather[0].main != "No data"  {
                title += " \(currentWeatherData.weather[0].main)"
            }
            
            if showCityName && currentWeatherData.name != "Unknown City" {
                if showDescription {
                    title += ","
                }
                title += " \(currentWeatherData.name)"
            }
            
            configureMenuButton(menuButton: menuButton, title: title, systemSymbolName: Utils.getIconByTimeConditionId(id: currentWeatherData.weather[0].id, dt:currentWeatherData.dt))
        }
    }
    
    @objc func menuButtonToggle(sender: AnyObject){
        if popOver.isShown{
            popOver.performClose(sender)
        } else {
            if let menuButton = AppDelegate.statusItem?.button{
                self.popOver.show(relativeTo: menuButton.bounds, of: menuButton, preferredEdge: NSRectEdge.minY)
                popOver.contentViewController?.view.window?.makeKey()
                weatherData.updateUIData()
                DispatchQueue.main.async {
                    NSApp.keyWindow?.makeFirstResponder(nil)
                }
            }
        }
    }
}
