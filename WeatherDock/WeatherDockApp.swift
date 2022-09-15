//
//  WeatherDockApp.swift
//  WeatherDock
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
    @AppStorage("dataSource") private static var dataSource = DefaultSettings.dataSource
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        
        //Start tracking onWake event
        fileNotifications()
        
        //Setting default data source
        setDataSource()

        //Loading application data
        weatherData.initData()
                
        //Setting up main pop-over view
        setupMainView()
        
        //Setting up menu item button
        setupMenuItem()
        
    }
    
    //Setting up main pop-over view
    private func setupMainView(){
        let mainView = MainView()
        popOver.behavior = .transient
        popOver.animates = true
        
        popOver.contentViewController = NSViewController()
        popOver.contentViewController?.view = NSHostingView(rootView: mainView)
    }
    
    //Setting up menu item button
    private func setupMenuItem(){
        AppDelegate.statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let menuButton = AppDelegate.statusItem?.button {
            AppDelegate.configureMenuButton(menuButton: menuButton, title: "--°\(Utils.getTempMeasurement())",
                                            systemSymbolName: weatherData.currentWeather.icon)
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
    private static func configureMenuButton(menuButton: NSStatusBarButton, title: String, systemSymbolName: String){
        menuButton.image = NSImage(systemSymbolName: systemSymbolName , accessibilityDescription: nil)
        let config = NSImage.SymbolConfiguration(textStyle: .title2)
        menuButton.image = menuButton.image?.withSymbolConfiguration(config)
        menuButton.imagePosition = NSControl.ImagePosition.imageLeft
        
        menuButton.title = title
    }
    
    //Menu item button update logic
    static func updateMenuButton(){
        let currentWeather = WeatherData.shared.currentWeather
        if let menuButton = AppDelegate.statusItem?.button {
            var title = ""
            
            if showTemperature {
                title += "\(currentWeather.temperature)°\(currentWeather.getTempUnit())"
            }
            
            if showDescription && currentWeather.short_desc != "No data"  {
                title += " \(currentWeather.short_desc)"
            }
            
            if showCityName && currentWeather.city != "Unknown City" {
                if showDescription {
                    title += ","
                }
                title += " \(currentWeather.city)"
            }
            
            configureMenuButton(menuButton: menuButton, title: title, systemSymbolName: currentWeather.icon)
        }
    }
    
    //Pop-over toggling logic
    @objc private func menuButtonToggle(sender: AnyObject){
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
    private func fileNotifications() {
        NSWorkspace.shared.notificationCenter.addObserver(
            self, selector: #selector(onWakeNote(note:)),
            name: NSWorkspace.didWakeNotification, object: nil)
    }
    
    //Updating all data on onWake event and resetting update timer
    @objc private func onWakeNote(note: NSNotification) {
        weatherData.getAllData()
        weatherData.setTimer()
    }
    
    //Setting default data source
    private func setDataSource(){
        if AppDelegate.dataSource == DataSource.unknown.rawValue {
            if #available(macOS 13, *) {
                AppDelegate.dataSource = DataSource.appleweather.rawValue
            } else {
                AppDelegate.dataSource = DataSource.openweather.rawValue
            }
        }
    }
}
