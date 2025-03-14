//
//  Texas_Hold_em_AssistanceApp.swift
//  Texas Hold'em Assistance
//
//  Created by Vincent on 2/21/25.
//

import SwiftUI

@main
struct Texas_Hold_em_AssistanceApp: App {
    // Provides access to the shared EditCardsModel which stores the current card selections.
    @State private var editCardsModel = EditCardsModel()
    
    // Tracks whether the splash screen should be dismissed.
    @State private var isActive = false
    
    var body: some Scene {
        WindowGroup {
            if isActive {
                ContentView()
                    .environment(editCardsModel)
            }else{
                SplashScreenView()
                // When the view appears, wait ~1 second before dismissing.
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        withAnimation(.easeOut) {
                            isActive = true
                        }
                    }
                }
                // Dismiss the splash screen immediately if the user taps anywhere.
                .onTapGesture {
                    withAnimation(.easeOut) {
                        print("Tapped Splash Screen.")
                        isActive = true
                    }
                }
            }
        }
    }
}
