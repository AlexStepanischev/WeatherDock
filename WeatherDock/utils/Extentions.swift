//
//  Extentions.swift
//  WeatherDock
//
//  Created by Aleksandr Stepanischev on 05/05/2022.
//

import SwiftUI

extension StringProtocol {
    var firstCapitalized: String { prefix(1).capitalized + dropFirst() }
}
