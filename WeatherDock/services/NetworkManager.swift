//
//  NetworkManager.swift
//  WeatherDock
//
//  Created by Aleksandr Stepanischev on 9/16/22.
//

import Foundation
import Network

class NetworkManager{
    let monitor = NWPathMonitor()
   
    init() {
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                //Re-initialising data every time connection back online
                WeatherData.shared.initData()
            } else {
                print("No connection.")
            }
        }
        
        let queue = DispatchQueue.main
        monitor.start(queue: queue)
    }
}
