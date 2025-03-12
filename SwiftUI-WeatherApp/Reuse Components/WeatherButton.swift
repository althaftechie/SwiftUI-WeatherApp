//
//  WeatherButton.swift
//  SwiftUI-WeatherApp
//
//  Created by Althaf'zMac on 08/03/25.
//

import SwiftUI

struct WeatherButton: View {
    var title: String
    var textColor: Color
    var backgroundColor: Color
    
    var body: some View {
        Text(title)
            .frame(width: 200, height: 50)
            .background(backgroundColor)
            .foregroundColor(textColor)
            .font(.headline)
            .cornerRadius(10)
            .shadow(radius: 5)
    }
}

#Preview {
    WeatherButton(title: "Change Mode", textColor: .blue, backgroundColor: .white)
}
