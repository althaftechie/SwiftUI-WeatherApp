//
//  WeatherConfig.swift
//  SwiftUI-WeatherApp
//
//  Created by Althaf'zMac on 08/03/25.
//


import Foundation

struct WeatherConfig {
    static var apiKey: String {
        guard let path = Bundle.main.path(forResource: "PrivacyThings", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path),
              let key = dict["WeatherAPI"] as? String else {
            fatalError("❌ API Key Not Found in PrivacyThings.plist")
        }
        return key
    }
}
