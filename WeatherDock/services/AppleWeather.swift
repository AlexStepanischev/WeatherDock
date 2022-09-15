//
//  AppleWeather.swift
//  WeatherDock
//
//  Created by Aleksandr Stepanischev on 9/1/22.
//

import SwiftUI
import WeatherKit
import CoreLocation

@available(macOS 13.0, *)
struct AppleWeather {
    private static let service = WeatherService()
    private static let weatherData = WeatherData.shared
    @AppStorage("unitsOfMeasurement") private static var unitsOfMeasurement = DefaultSettings.unitsOfMeasurement
    
    static func loadAllDataByCity(city: String){
        LocationManager.shared.getLocationFrom(cityName: city) { newLocation, error in
            let weatherData = WeatherData.shared
            weatherData.location = newLocation
            
            if (newLocation.coordinate.latitude, newLocation.coordinate.longitude) == (0.0, 0.0) {
                weatherData.currentWeather = CurrentWeatherData()
                weatherData.airPollution = AirPollution()
                weatherData.dailyForecast = DailyForecast(day_data: DayData.getEmptyArray())
                weatherData.hourlyForecast = HourlyForecast(hour_data: HourData.getEmptyArray())
                weatherData.city = "Unknown City"
                weatherData.refreshView()
            } else {
                loadAllDataByLocation(location: newLocation)
            }
        }
    }
    
    static func loadAllDataByLocation(location: CLLocation){
        Task {
            do {
                let result = try await service.weather(for: location, including: .current, .daily, .hourly)
                let newAirPollutionData = await OpenWeather.getAirPollutionData(location: location)
                
                DispatchQueue.main.async {
                    updateCurrentWeatherDataWith(data: result.0, day: result.1[0])
                    OpenWeather.updateAirPollutionWith(data: newAirPollutionData)
                    updateDailyForecastWith(dailyData: result.1, hourlyData: result.2)
                    updateHourlyForecastWith(data: result.2)
                    
                    LocationManager.shared.getTimezoneFrom(location: location) { placemark, error in
                        var city = "Unknown City"
                        if placemark != nil && placemark!.count > 0 {
                            city = placemark![0].locality ?? "Unknown City"
                        }
                        weatherData.city = city
                        AppDelegate.updateMenuButton()
                        print("[WeatherKit] All weather updated at: \(Utils.getDateTimefromUnix(dt: weatherData.currentWeather.dt, timezone: weatherData.currentWeather.timezone))")
                    }
                }
            } catch {
                print(String(describing: error))
            }
        }
    }
    
    private static func updateCurrentWeatherDataWith(data: CurrentWeather, day: DayWeather){
        var newCurrentWeather = CurrentWeatherData()
        newCurrentWeather.dt = data.date.timeIntervalSince1970
        
        newCurrentWeather.icon = data.symbolName
        
        if unitsOfMeasurement == UnitsOfMeasurement.metric.rawValue {
            newCurrentWeather.temperature = Int(data.temperature.converted(to: .celsius).value.rounded())
        } else {
            newCurrentWeather.temperature = Int(data.temperature.converted(to: .fahrenheit).value.rounded())
        }
        
        newCurrentWeather.description = data.condition.description
        newCurrentWeather.short_desc = Utils.getLastWord(description: data.condition.description)
        
        if unitsOfMeasurement == UnitsOfMeasurement.metric.rawValue {
            newCurrentWeather.feels_like = Int(data.apparentTemperature.converted(to: .celsius).value.rounded())
        } else {
            newCurrentWeather.feels_like = Int(data.apparentTemperature.converted(to: .fahrenheit).value.rounded())
        }
        
        newCurrentWeather.sunrise = day.sun.sunrise?.timeIntervalSince1970 ?? 0.0
        newCurrentWeather.sunset = day.sun.sunset?.timeIntervalSince1970 ?? 0.0
        
        newCurrentWeather.humidity = Int(round(data.humidity*100))
        
        if unitsOfMeasurement == UnitsOfMeasurement.metric.rawValue {
            newCurrentWeather.wind_speed = Int(data.wind.speed.converted(to: .metersPerSecond).value.rounded())
        } else {
            newCurrentWeather.wind_speed = Int(data.wind.speed.converted(to: .milesPerHour).value.rounded())
        }

        newCurrentWeather.pressure = Int(data.pressure.converted(to: .hectopascals).value.rounded())
        
        LocationManager.shared.getTimezoneFrom(location: data.metadata.location) { placemark, error in
            if placemark != nil && placemark!.count > 0 {
                newCurrentWeather.timezone = placemark![0].timeZone?.secondsFromGMT() ?? 0
                newCurrentWeather.city = placemark![0].locality ?? "Unknown City"
            }
            weatherData.currentWeather = newCurrentWeather
            AppDelegate.updateMenuButton()
        }
        
    }
    
    private static func updateHourlyForecastWith(data: Forecast<HourWeather>){
        
        var newHourDataArray: [HourData] = []
        
        for updatedHour in data.forecast {
            var newHourData = HourData()
            newHourData.dt = updatedHour.date.timeIntervalSince1970
            
            if unitsOfMeasurement == UnitsOfMeasurement.metric.rawValue {
                newHourData.temperature = Int(updatedHour.temperature.converted(to: .celsius).value.rounded())
            } else {
                newHourData.temperature = Int(updatedHour.temperature.converted(to: .fahrenheit).value.rounded())
            }
            
            newHourData.precipitation = Int(round(updatedHour.precipitationChance*100))
            newHourData.icon = updatedHour.symbolName
            
            newHourDataArray.append(newHourData)
        }
        
        LocationManager.shared.getTimezoneFrom(location: data.metadata.location) { placemark, error in
            var timezone = 0
            if placemark != nil && placemark!.count > 0 {
                timezone = placemark![0].timeZone?.secondsFromGMT() ?? 0
            }
            WeatherData.shared.hourlyForecast = HourlyForecast(hour_data: newHourDataArray)
            WeatherData.shared.hourlyForecast.timezone_offset = timezone
        }
    }
    
    private static func updateDailyForecastWith(dailyData: Forecast<DayWeather>, hourlyData: Forecast<HourWeather>){
        
        var newDayDataArray: [DayData] = []
        
        for updatedDay in dailyData.forecast {
            var newDayData = DayData()
            newDayData.dt = updatedDay.date.timeIntervalSince1970
            
            if unitsOfMeasurement == UnitsOfMeasurement.metric.rawValue {
                newDayData.temperature = Int(updatedDay.highTemperature.converted(to: .celsius).value.rounded())
            } else {
                newDayData.temperature = Int(updatedDay.highTemperature.converted(to: .fahrenheit).value.rounded())
            }
            
            if unitsOfMeasurement == UnitsOfMeasurement.metric.rawValue {
                newDayData.temperature_night = Int(updatedDay.lowTemperature.converted(to: .celsius).value.rounded())
            } else {
                newDayData.temperature_night = Int(updatedDay.lowTemperature.converted(to: .fahrenheit).value.rounded())
            }
            
            newDayData.description = updatedDay.condition.description
            newDayData.short_desc = Utils.getLastWord(description: updatedDay.condition.description)
            
            newDayData.sunrise = updatedDay.sun.sunrise?.timeIntervalSince1970 ?? 0.0
            newDayData.sunset = updatedDay.sun.sunset?.timeIntervalSince1970 ?? 0.0
            
            let noonData = getNoonHourlyDataForDate(date: updatedDay.date, hourlyData: hourlyData)
            newDayData.feels_like = noonData.0
            newDayData.humidity = noonData.1
            newDayData.pressure = noonData.2
            
            if unitsOfMeasurement == UnitsOfMeasurement.metric.rawValue {
                newDayData.wind_speed = Int(updatedDay.wind.speed.converted(to: .metersPerSecond).value.rounded())
            } else {
                newDayData.wind_speed = Int(updatedDay.wind.speed.converted(to: .milesPerHour).value.rounded())
            }
            
            newDayData.precipitation = Int(round(updatedDay.precipitationChance*100))
            newDayData.icon = updatedDay.symbolName
            
            newDayDataArray.append(newDayData)
        }
        
        LocationManager.shared.getTimezoneFrom(location: dailyData.metadata.location) { placemark, error in
            var timezone = 0
            if placemark != nil && placemark!.count > 0 {
                timezone = placemark![0].timeZone?.secondsFromGMT() ?? 0
            }
            WeatherData.shared.dailyForecast = DailyForecast(day_data: newDayDataArray)
            WeatherData.shared.dailyForecast.timezone = timezone
        }
    }
    
    static private func getNoonHourlyDataForDate(date: Date, hourlyData: Forecast<HourWeather>) -> (Int, Int, Int){
        let noonDate = date.addingTimeInterval(13 * 60 * 60)
        for hour in hourlyData{
            if hour.date == noonDate {
                let humidity = Int(round(hour.humidity*100))
                let pressure = Int(hour.pressure.converted(to: .hectopascals).value.rounded())
                var feels_like = 888
                if unitsOfMeasurement == UnitsOfMeasurement.metric.rawValue {
                    feels_like = Int(hour.apparentTemperature.converted(to: .celsius).value.rounded())
                } else {
                    feels_like = Int(hour.apparentTemperature.converted(to: .fahrenheit).value.rounded())
                }
                
                return (feels_like, humidity, pressure)
            }
        }
        return (888,888,888)
    }
}
