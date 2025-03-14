//
//  LaunchBoardView.swift
//  Texas Hold'em Assistance
//
//  Created by Vincnet on 2/23/25.
//
import SwiftUI

/// SplashScreenView displays a full-screen splash view when the app launches.
struct SplashScreenView: View {
    
    // Tracks whether the splash screen should be dismissed.
    @State private var isActive = false
    
    var body: some View {
            VStack {
                Spacer()
                
                Text("♥️♠️♦️♣️")
                    .font(.system(size: 80))
                    
                Text("Texas Hold'em Assistance")
                    .font(.system(size: 50, weight: .bold))
                    .multilineTextAlignment(.center)
                    .fontWeight(.bold)
                    .padding(.top, 20)
                
                Spacer()
                
                Text("Vincent Lin")
                    .font(.title)
                    .foregroundColor(.gray)
                    
                Text("Weixaing")
                    .font(.title)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black.ignoresSafeArea())
            .foregroundColor(.white)
        }
}

#Preview {
    SplashScreenView()
}
