//
//  Utils.swift
//  WeatherDock
//
//  Created by Aleksandr Stepanischev on 05/05/2022.
//

import SwiftUI

struct Utils {
    @AppStorage("unitsOfMeasurement") private static var unitsOfMeasurement = DefaultSettings.unitsOfMeasurement
    @AppStorage("pressureUnit") private static var pressureUnit = DefaultSettings.pressureUnit
    @AppStorage("timeFormat") private static var timeFormat = DefaultSettings.timeFormat
    
    static func getPressureValueUnit(hPa: Int) -> String {
        if pressureUnit == PressureUnits.inHg.rawValue {
            let value = Double(hPa)/33.864
            let inHg = String(format: "%.2f", value)
        
            return "\(inHg) inHg"
        
        } else if pressureUnit == PressureUnits.mmHg.rawValue {
            let value = Double(hPa)/1.333
            let mmHg = String(format: "%.0f", value)
        
            return "\(mmHg) mmHg"
        } else {
            return "\(hPa) hPa"
        }
    }
    
    static func getTempMeasurement() -> String {
        if unitsOfMeasurement == UnitsOfMeasurement.metric.rawValue {
            return "C"
        } else {
            return "F"
        }
    }
    
    static func getSpeedMeasurement() -> String {
        if unitsOfMeasurement == UnitsOfMeasurement.metric.rawValue {
            return "m/s"
        } else {
            return "mph"
        }
    }
    
    static func getTimefromUnix(dt: Double, timezone: Int) -> String {
        let date = Date(timeIntervalSince1970: dt)
        
        var dateFormat24 = Date.FormatStyle()
            .hour(.twoDigits(amPM: .omitted))
            .minute(.twoDigits)
        
        dateFormat24.timeZone = TimeZone(secondsFromGMT: timezone)!
        
        var dateFormat12 = Date.FormatStyle()
            .hour(.conversationalDefaultDigits(amPM: .abbreviated))
        
        dateFormat12.timeZone = TimeZone(secondsFromGMT: timezone)!
        
        if timeFormat == TimeFormat.twentyfour.rawValue {
            return dateFormat24.format(date)
        } else {
            return dateFormat12.format(date)
        }
    }
    
    static func getLongTimefromUnix(dt: Double, timezone: Int) -> String {
        let date = Date(timeIntervalSince1970: dt)
        
        var dateFormat24 = Date.FormatStyle()
            .hour(.twoDigits(amPM: .omitted))
            .minute(.twoDigits)
        
        dateFormat24.timeZone = TimeZone(secondsFromGMT: timezone)!
        
        var dateFormat12 = Date.FormatStyle()
            .hour(.conversationalDefaultDigits(amPM: .abbreviated))
            .minute(.twoDigits)
        
        dateFormat12.timeZone = TimeZone(secondsFromGMT: timezone)!
        
        if timeFormat == TimeFormat.twentyfour.rawValue {
            return dateFormat24.format(date)
        } else {
            return dateFormat12.format(date)
        }
    }
    
    static func getDateTimefromUnix(dt: Double, timezone: Int) -> String {
        let date = Date(timeIntervalSince1970: dt)
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.long
        dateFormatter.dateStyle = DateFormatter.Style.long
        
        dateFormatter.timeZone = .init(secondsFromGMT: timezone)
        
        let localTime = dateFormatter.string(from: date)
        return localTime
    }
    
    static func getDate(dt: Double, timezone: Int) -> String {
        let date = Date(timeIntervalSince1970: dt)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .init(secondsFromGMT: timezone)
        dateFormatter.dateStyle = .full
        
        let result = dateFormatter.string(from: date)
        
        return result
    }
    
    static func getDayDate(dt: Double, timezone: Int) -> (String, String) {
        let dateTime = Date(timeIntervalSince1970: dt)
        
        let dayFormatter = DateFormatter()
        dayFormatter.timeZone = .init(secondsFromGMT: timezone)
        dayFormatter.dateFormat = "E"
        
        let day = dayFormatter.string(from: dateTime)
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .init(secondsFromGMT: timezone)
        dateFormatter.dateFormat = "MMM d"
        
        let date = dateFormatter.string(from: dateTime)
        
        return (day, date)
    }
    static func getIconByConditionId(id: Int) -> String {
        return icons[id]?.0 ?? "cloud.sun"
    }
    
    static func getIconByTimeConditionId(id: Int, dt: Double) -> String {
        let currentWeather = WeatherData.shared.currentWeather
        let sunriseToday = currentWeather.sunrise
        let sunsetToday = currentWeather.sunset
        
        let dailyForecast = WeatherData.shared.dailyForecast
        
        if dailyForecast.getDailyTrimmed().isEmpty {
            return icons[id]?.0 ?? "cloud.sun"
        }
        
        let sunriseTomorrow = dailyForecast.getDailyTrimmed()[0].sunrise
        let sunsetTomorrow = dailyForecast.getDailyTrimmed()[0].sunset
        
        if (dt > sunriseToday && dt < sunsetToday) || (dt > sunriseTomorrow && dt < sunsetTomorrow) {
            return icons[id]?.0 ?? "cloud.sun"
        } else {
            return icons[id]?.1 ?? "cloud.moon"
        }
    }
    
    static let icons = [
        
        200: ("cloud.bolt.rain", "cloud.bolt.rain"),
        201: ("cloud.bolt.rain", "cloud.bolt.rain"),
        202: ("cloud.bolt.rain", "cloud.bolt.rain"),
        210: ("cloud.sun.bolt", "cloud.moon.bolt"),
        211: ("cloud.bolt", "cloud.bolt"),
        212: ("cloud.bolt", "cloud.bolt"),
        221: ("cloud.bolt", "cloud.bolt"),
        230: ("cloud.bolt.rain", "cloud.bolt.rain"),
        231: ("cloud.bolt.rain", "cloud.bolt.rain"),
        232: ("cloud.bolt.rain", "cloud.bolt.rain"),
        
        300: ("cloud.drizzle","cloud.drizzle"),
        301: ("cloud.drizzle","cloud.drizzle"),
        302: ("cloud.drizzle","cloud.drizzle"),
        310: ("cloud.rain", "cloud.rain"),
        311: ("cloud.rain", "cloud.rain"),
        312: ("cloud.heavyrain", "cloud.heavyrain"),
        313: ("cloud.heavyrain", "cloud.heavyrain"),
        314: ("cloud.heavyrain", "cloud.heavyrain"),
        321: ("cloud.heavyrain", "cloud.heavyrain"),
        
        500: ("cloud.sun.rain", "cloud.moon.rain"),
        501: ("cloud.sun.rain", "cloud.moon.rain"),
        502: ("cloud.sun.rain", "cloud.moon.rain"),
        503: ("cloud.sun.rain", "cloud.moon.rain"),
        504: ("cloud.sun.rain", "cloud.moon.rain"),
        511: ("cloud.hail", "cloud.hail"),
        520: ("cloud.heavyrain", "cloud.heavyrain"),
        521: ("cloud.heavyrain", "cloud.heavyrain"),
        522: ("cloud.heavyrain", "cloud.heavyrain"),
        531: ("cloud.heavyrain", "cloud.heavyrain"),
        
        600: ("cloud.snow", "cloud.snow"),
        601: ("cloud.snow", "cloud.snow"),
        602: ("cloud.snow", "cloud.snow"),
        611: ("cloud.sleet", "cloud.sleet"),
        612: ("cloud.sleet", "cloud.sleet"),
        613: ("cloud.sleet", "cloud.sleet"),
        615: ("cloud.sleet", "cloud.sleet"),
        616: ("cloud.sleet", "cloud.sleet"),
        620: ("snowflake", "snowflake"),
        621: ("snowflake", "snowflake"),
        622: ("snowflake", "snowflake"),
        
        701: ("cloud.fog", "cloud.fog"),
        711: ("smoke", "smoke"),
        721: ("sun.haze", "sun.haze"),
        731: ("sun.dust", "sun.dust"),
        741: ("cloud.fog", "cloud.fog"),
        751: ("sun.dust", "sun.dust"),
        761: ("sun.dust", "sun.dust"),
        762: ("sun.dust", "sun.dust"),
        771: ("tropicalstorm", "tropicalstorm"),
        781: ("tornado", "tornado"),
        
        800: ("sun.max", "moon.stars"),
        
        801: ("cloud.sun", "cloud.moon"),
        802: ("cloud", "cloud"),
        803: ("cloud", "cloud"),
        804: ("cloud", "cloud")
    ]
    
    static let aqi = [
        0: ("Unknown", "aqi.low"),
        1: ("Good", "aqi.low"),
        2: ("Fair", "aqi.medium"),
        3: ("Moderate", "aqi.medium"),
        4: ("Poor", "aqi.high"),
        5: ("Very Poor", "aqi.high")
    ]
}
