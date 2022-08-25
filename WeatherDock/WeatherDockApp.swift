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
    var menu: NSMenu!
    var popOver = NSPopover()
    
    let weatherData = WeatherData.shared
    
    @AppStorage("showTemperature") private static var showTemperature = DefaultSettings.showTemperature
    @AppStorage("showDescription") private static var showDescription = DefaultSettings.showDescription
    @AppStorage("showCityName") private static var showCityName = DefaultSettings.showCityName
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        
        //Start tracking onWake event
        fileNotifications()

        //Loading application data
        weatherData.getAllData()
                
        //Setting up main pop-over view
        setupMainView()
        
        //Setting up menu item button
        setupMenuItem()
        
    }
    
    //Setting up main pop-over view
    func setupMainView(){
        let mainView = MainView()
        popOver.behavior = .transient
        popOver.animates = true
        
        popOver.contentViewController = NSViewController()
        popOver.contentViewController?.view = NSHostingView(rootView: mainView)
    }
    
    //Setting up menu item button
    func setupMenuItem(){
        AppDelegate.statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let menuButton = AppDelegate.statusItem?.button {
            AppDelegate.configureMenuButton(menuButton: menuButton, title: "--°\(Utils.getTempMeasurement())",
                                            systemSymbolName: Utils.getIconByTimeConditionId(id: weatherData.currentWeatherData.weather[0].id,
                                                                                         dt: weatherData.currentWeatherData.dt))
            menuButton.action = #selector(menuButtonToggle)
            menuButton.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }
        
        //Adding right click menu
        let statusBarMenu = NSMenu(title: "Status Bar Menu")
        statusBarMenu.addItem(
                    withTitle: "Quit",
                    action: #selector(AppDelegate.quit),
                    keyEquivalent: "")

        menu = statusBarMenu
    }
    
    //Menu item button presentation configuration
    static func configureMenuButton(menuButton: NSStatusBarButton, title: String, systemSymbolName: String){
        menuButton.image = NSImage(systemSymbolName: systemSymbolName , accessibilityDescription: nil)
        let config = NSImage.SymbolConfiguration(textStyle: .title2)
        menuButton.image = menuButton.image?.withSymbolConfiguration(config)
        menuButton.imagePosition = NSControl.ImagePosition.imageLeft
        
        menuButton.title = title
    }
    
    //Menu item button update logic
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
    
    //Pop-over toggling logic
    @objc func menuButtonToggle(sender: AnyObject){
        let event = NSApp.currentEvent!

        if event.type ==  NSEvent.EventType.rightMouseUp {
            AppDelegate.statusItem!.menu = menu
            AppDelegate.statusItem!.button?.performClick(nil)
            AppDelegate.statusItem!.menu = nil
        } else {
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
    
    //Quit app function
    @objc func quit() {
        NSApplication.shared.terminate(self)
    }

    //Tracking onWake event
    func fileNotifications() {
        NSWorkspace.shared.notificationCenter.addObserver(
            self, selector: #selector(onWakeNote(note:)),
            name: NSWorkspace.didWakeNotification, object: nil)
    }
    
    //Updating all data on onWake event and resetting update timer
    @objc func onWakeNote(note: NSNotification) {
        weatherData.getAllData()
        weatherData.setTimer()
    }
}
