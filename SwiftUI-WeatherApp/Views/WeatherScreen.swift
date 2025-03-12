//
//  ContentView.swift
//  SwiftUI-WeatherApp
//
//  Created by Althaf'zMac on 08/03/25.


import SwiftUI

struct WeatherScreen: View {
    @StateObject private var viewModel = WeatherViewModel()
    @State private var isDark = false
    @State private var cityName = "Chennai"
    @State private var showWeather = false

    var body: some View {
        ZStack {
            BackgroundColorView(isNight: isDark)
                .transition(.opacity)
                .animation(.easeInOut(duration: 0.5), value: isDark)
            VStack {
                Spacer()

                CityNameText(cityName: $cityName, viewModel: viewModel)

                if viewModel.errorMessage != nil {
                    OOPSImage(viewModel: viewModel)

                } else {
                    if showWeather {
                        MainWeatherStatusView(mainImageName: viewModel.weatherIcon, mainTemp: viewModel.temperature)
                            .transition(.scale.combined(with: .opacity))
                            .animation(.spring(response: 0.5, dampingFraction: 0.7), value: showWeather)

                        HStack(spacing: 20) {
                            if viewModel.weeklyForecast.isEmpty {
                                Text("No forecast data!")
                                    .foregroundColor(.white)
                            } else {
                                let forecastList = Array(viewModel.weeklyForecast.prefix(5))
                                ForEach(forecastList, id: \.id) { forecast in
                                    WeatherDaysView(
                                        dayOfWeek: forecast.dayOnly,
                                        imageNameForDayOfWeek: forecast.weatherIcon,
                                        temperatureForDayOfWeek: Int(forecast.main.temp)
                                    )
                                    .transition(.opacity.combined(with: .slide))
                                    .animation(.easeInOut(duration: 0.6).delay(0.1), value: showWeather)
                                }
                            }
                        }
                    }
                }

                Spacer()

                Button {
                    isDark.toggle()
                } label: {
                    WeatherButton(title: isDark ? "Change LightMode" : "Change DarkMode", textColor: .blue, backgroundColor: .white)
                }
                .transition(.scale)
                .animation(.easeInOut(duration: 0.3), value: isDark)

                Spacer()
            }
            .ignoresSafeArea(.keyboard)
            .padding()
        }
        
        .onAppear {
            viewModel.fetchWeather(for: "Chennai")
            viewModel.fetchWeeklyForecast(for: "Chennai")

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation {
                    showWeather = true
                }
            }
        }
    }
}

#Preview {
    WeatherScreen()
}

struct BackgroundColorView: View {
    var isNight: Bool
    var body: some View {
        ContainerRelativeShape()
            .fill(isNight ? Color.black.gradient : Color.blue.gradient)
            .ignoresSafeArea()
    }
}

struct WeatherDaysView: View {
    var dayOfWeek: String
    var imageNameForDayOfWeek: String
    var temperatureForDayOfWeek: Int

    var body: some View {
        VStack {
            Text(dayOfWeek)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white)
            Image(systemName: imageNameForDayOfWeek)
                .symbolRenderingMode(.multicolor)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
            Text("\(temperatureForDayOfWeek)°")
                .font(.system(size: 28, weight: .medium))
                .foregroundColor(.white)
        }
    }
}

struct CityNameText: View {
    @Binding var cityName: String
    var viewModel: WeatherViewModel

    var body: some View {
        VStack {
            TextField("Enter city name", text: $cityName, onCommit: {
                viewModel.fetchWeather(for: cityName)
                viewModel.fetchWeeklyForecast(for: cityName)
            })
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
            .font(.system(size: 32, weight: .medium))
            .foregroundColor(.blue)
            .multilineTextAlignment(.center)
            .fixedSize()
            .frame(maxWidth: 250)
            .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.2)))


            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.red)
                    .padding(.top, 5)
            }
        }
    }
}


struct MainWeatherStatusView: View {
    var mainImageName: String
    var mainTemp: String
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: mainImageName)
                .resizable()
                .symbolRenderingMode(.multicolor)
                .aspectRatio(contentMode: .fit)
                .frame(width: 180, height: 180)

            Text(mainTemp)
                .font(.system(size: 70, weight: .medium))
                .foregroundColor(.white)
        }
        .padding(.bottom, 40)
    }
}

struct OOPSImage: View {

    var viewModel: WeatherViewModel

    var body: some View {
        Image("oops")
            .resizable()
            .scaledToFit()
            .frame(width: 250, height: 250)
            .padding()
            .transition(.opacity)
            .animation(.easeInOut(duration: 0.5), value: viewModel.errorMessage)
    }
}
