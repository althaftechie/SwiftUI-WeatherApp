//
//  WeatherViewModel.swift
//  SwiftUI-WeatherApp
//
//  Created by Althaf'zMac on 08/03/25.
//


import Foundation

class WeatherViewModel: ObservableObject {
    @Published var cityName: String = "Loading"
    @Published var temperature: String = "--°"
    @Published var weatherIcon: String = ""
    @Published var weeklyForecast: [ForecastItem] = []
    @Published var errorMessage: String?

    private let apiKey = WeatherConfig.apiKey
   
    func fetchWeather(for city: String) {
        let trimmedCity = city.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedCity.isEmpty else {
            DispatchQueue.main.async { self.errorMessage = "Please type city name" }
            return
        }
        
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(trimmedCity)&units=metric&appid=\(apiKey)"

        guard let url = URL(string: urlString) else {
         //   DispatchQueue.main.async { self.errorMessage = "Invalid URL!" }
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
  //          if let error = error {
         //       DispatchQueue.main.async { self.errorMessage = "Error fetching weather: \(error.localizedDescription)" }
 //               return
  //          }

            guard let data = data else {
       //         DispatchQueue.main.async { self.errorMessage = "No data received!" }
                return
            }

            do {
                // ✅ API Response Validation
                if (try? JSONDecoder().decode(APIError.self, from: data)) != nil {
                    DispatchQueue.main.async { self.errorMessage = "Enter a valid city name" }
                    return
                }

                let weatherData = try JSONDecoder().decode(WeatherModel.self, from: data)
                DispatchQueue.main.async {
                    self.cityName = weatherData.name
                    self.temperature = weatherData.temperature
                    self.weatherIcon = weatherData.weatherIcon
                    self.errorMessage = nil
                }
            } catch {
              //  DispatchQueue.main.async { self.errorMessage = "Failed to decode weather data!" }
            }
        }.resume()
    }

    func fetchWeeklyForecast(for city: String) {
        let urlString = "https://api.openweathermap.org/data/2.5/forecast?q=\(city)&units=metric&appid=\(apiKey)"

        guard let url = URL(string: urlString) else {
   //         DispatchQueue.main.async { self.errorMessage = "Invalid URL!" }
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if error != nil {
                DispatchQueue.main.async {
  //                  self.errorMessage = "Error fetching forecast: \(error.localizedDescription)"
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    self.errorMessage = "No data received!"
                }
                return
            }

            do {
                let forecastData = try JSONDecoder().decode(ForecastResponse.self, from: data)

                let groupedForecast = Dictionary(grouping: forecastData.list, by: { $0.dateOnly })

                let finalForecast = groupedForecast.compactMap { (_, forecasts) in
                    forecasts.first { $0.dt_txt.contains("12:00:00") } ?? forecasts.first
                }

                DispatchQueue.main.async {
                    self.weeklyForecast = Array(finalForecast.prefix(5)) // ✅ Convert to Array explicitly
                    self.errorMessage = nil
                }
            } catch {
                DispatchQueue.main.async {
                  //  self.errorMessage = "Failed to decode forecast data!"
                }
            }
        }.resume()
    }
}
