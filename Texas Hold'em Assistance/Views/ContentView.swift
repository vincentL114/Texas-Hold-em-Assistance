//
//  ContentView.swift
//  Texas Hold'em Assistance
//
//  Created by Vincent on 2/21/25.
//

import SwiftUI

struct ContentView: View {
    // Controls whether to show the rating alert.
    @State private var showRatingAlert = false
    
    var body: some View {
        TabView {
            CalculatorView()
                .tabItem {
                    Image(systemName: "plus.slash.minus")
                    Text("Calculator")
                }
            
            HandGuideView()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Hand Guide")
                }
            
            GameJournalView()
                .tabItem {
                    Image(systemName: "book")
                    Text("Journal")
                }
        }
        .accentColor(.black)
        .onAppear {
            // Increment the launch count.
            let currentCount = UserDefaults.standard.integer(forKey: "launchCount")
            let newCount = currentCount + 1
            UserDefaults.standard.set(newCount, forKey: "launchCount")
            print("App launch count: \(newCount)")
            
            // Show the alert on the 3rd launch.
            if newCount == 3 {
                showRatingAlert = true
            }
            
            let defaultPreferences: [String: Any] = [
                "developer_name": "Vincent Lin"
            ]
            UserDefaults.standard.register(defaults: defaultPreferences)
            
            // Store initial launch date if not set
            if UserDefaults.standard.object(forKey: "Initial Launch") == nil {
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                formatter.timeStyle = .medium
                formatter.timeZone = .current // or .autoupdatingCurrent
                let localDate = formatter.string(from: Date())
                
                UserDefaults.standard.set(localDate, forKey: "Initial Launch")
                print("Setting 'Initial Launch' to \(localDate)")
            }
        }
        .alert("Enjoying Texas Hold'em Assistance?", isPresented: $showRatingAlert) {
            Button("Rate Now") {
                print("Rate Now pressed.")
            }
            Button("Later") {
                print("Later pressed.")
            }
        } message: {
            Text("Tap to rate it on the App Store!")
        }
    }
    
}

#Preview {
    ContentView()
        .environment(EditCardsModel())
}
