//
//  SplashScreen.swift
//  SwiftUI-WeatherApp
//
//  Created by Althaf'zMac on 08/03/25.
//

import SwiftUI

struct SplashScreen: View {
    @State private var isActive = false
    
    var body: some View {
        if isActive {
            WeatherScreen()
        } else {
            ZStack {
                Color.white.ignoresSafeArea()
                LottieView(animationName: "snowfall", loopMode: .playOnce)
                    .frame(width: 300, height: 300)
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation {
                        isActive = true
                    }
                }
            }
        }
    }
}


#Preview {
    SplashScreen()
}
