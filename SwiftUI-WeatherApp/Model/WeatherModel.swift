//
//  WeatherModel.swift
//  SwiftUI-WeatherApp
//
//  Created by Althaf'zMac on 08/03/25.
//

import Foundation

// 🌍 Current Weather Model
struct WeatherModel: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
    
    // 🌡 Temperature formatted (e.g., "25.3°")
    var temperature: String {
        return String(format: "%.1f°", main.temp)
    }
    
    // ☁️ Weather Icon Mapping
    var weatherIcon: String {
        guard let icon = weather.first?.icon else { return "questionmark" }
        return WeatherIconMapper.map(icon: icon)
    }
}

// 🌡 Temperature Data
struct Main: Codable {
    let temp: Double
}

// 🌤 Weather Description & Icon
struct Weather: Codable {
    let description: String
    let icon: String
}

struct APIError: Codable {
    let message: String
}

// 📊 Forecast Response Model
struct ForecastResponse: Codable {
    let list: [ForecastItem]
}

// 📅 Individual Forecast Item
struct ForecastItem: Codable, Identifiable {
    var id: String { dt_txt } // API-ல் இல்லாத "id", Unique "dt_txt" கொண்டு உருவாக்கப்படும்
    let dt_txt: String
    let main: MainData
    let weather: [WeatherItem]
    
    // 🗓 Extract Date (YYYY-MM-DD)
    var dateOnly: String {
        return String(dt_txt.prefix(10))
    }
    
    // 📆 Extract Short Day Name (e.g., "Mon", "Tue")
    var dayOnly: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date = dateFormatter.date(from: dt_txt) {
            dateFormatter.dateFormat = "EEE" // Short day name (Mon, Tue, Wed...)
            return dateFormatter.string(from: date)
        }
        return "--"
    }

    // ☁️ Forecast Weather Icon Mapping
    var weatherIcon: String {
        guard let icon = weather.first?.icon else { return "questionmark" }
        return WeatherIconMapper.map(icon: icon)
    }
}

// 🌡 Temperature Data (For Forecast)
struct MainData: Codable {
    let temp: Double
}

// 🌤 Individual Weather Data (For Forecast)
struct WeatherItem: Codable {
    let description: String
    let icon: String
}

// 🔄 Helper to map OpenWeather icons to SF Symbols
struct WeatherIconMapper {
    static func map(icon: String) -> String {
        switch icon {
        case "01d": return "sun.max.fill"
        case "01n": return "moon.stars.fill"
        case "02d", "02n": return "cloud.sun.fill"
        case "03d", "03n": return "cloud.fill"
        case "04d", "04n": return "cloud.fog.fill" // Updated (smoke.fill → cloud.fog.fill)
        case "09d", "09n": return "cloud.heavyrain.fill"
        case "10d", "10n": return "cloud.rain.fill"
        case "11d", "11n": return "cloud.bolt.fill"
        case "13d", "13n": return "snowflake"
        case "50d", "50n": return "wind"
        default: return ""
        }
    }
}
