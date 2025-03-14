//
//  AddGameView.swift
//  Texas Hold'em Assistance
//
//  Created by Vincent on 3/6/25.
//

import SwiftUI


/// AddGameView presents a form for creating a new game record.
struct AddGameView: View {
    // Environment dismiss action to close the view.
    @Environment(\.dismiss) var dismiss
    
    // Shared model that holds the current card selections.
    @Environment(EditCardsModel.self) var editCardsModel
    
    // Controls the display of alerts when game saving conditions are not met.
    @State private var showAlert = false
    
    // Game name
    @State private var gameName: String = ""
    
    // User-selected status for the game (win, fold, loss, not played).
    @State private var status: String = "win"
    
    // The date and time when the game was played.
    @State private var gameTime: Date = Date()
    
    // The number of chips entered as a string.
    @State private var chipsAmount: String = ""
    
    // A computed property that determines the outcome label based on the game status.
    private var outcome: String {
        status == "not played" ? "Not Played" : (status == "fold" || status == "loss" ? "Loss" : "Win")
    }
   
    // Determines if the Save button should be enabled.
    var canSave: Bool {
        editCardsModel.startingHand.count == 2 && (editCardsModel.communityCards.isEmpty || editCardsModel.communityCards.count >= 3)
    }
    
    // List of possible statuses for the game.
    let statuses = ["win", "fold", "loss","not played"]
    
    var body: some View {
        NavigationView {
                // Game Information Form
                Form {
                    // TextField for entering the game name.
                    Section(header: Text("Game Info")) {
                        TextField("Game Name", text: $gameName)
                        VStack(alignment: .leading, spacing: 16) {
                            // Segmented Picker for selecting the game status.
                            Picker("Status", selection: $status) {
                                ForEach(statuses, id: \.self) { stat in
                                    Text(stat.capitalized).tag(stat)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            
                            // HStack for chip amount input and outcome label.
                            HStack {
                                TextField("Enter \(outcome.capitalized) Chips", text:status == "not played" ? .constant("0"): $chipsAmount)
                                    .keyboardType(.numberPad)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .disabled(status == "not played")
                                
                                // Outcome label based on status
                                Text(outcome)
                                    .padding(.leading, 8)
                                    .foregroundColor(status == "not played" ? .gray : (status == "fold" || status == "loss" ? .red : .green))
                            }
                        }
                        
                        // DatePicker for selecting the game time.
                        DatePicker("Game Time", selection: $gameTime, displayedComponents: [.date, .hourAndMinute])
                    }
                    .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                    
                    
                    // Card Selection Preview
                    Section(header: Text("Card Selection")){
                        VStack(spacing: 5) {
                            
                            // Starting Hand
                            VStack {
                                Text("Starting Hand")
                                    .font(.title2)
                                    .bold()
                                
                                HStack(spacing: 10) {
                                    ForEach(editCardsModel.startingHand) { card in
                                        CardView(card: card)
                                    }
                                    if editCardsModel.startingHand.isEmpty {
                                        Text("No Cards Selected")
                                            .foregroundColor(.gray)
                                    }
                                }
                                .frame(height: 80)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding()
                                .background(Color(UIColor.secondarySystemBackground))
                                .cornerRadius(12)
                            }
                            
                            // Community Cards
                            VStack {
                                Text("Community Cards")
                                    .font(.title2)
                                    .bold()
                                
                                HStack(spacing: 10) {
                                    ForEach(editCardsModel.communityCards) { card in
                                        CardView(card: card)
                                    }
                                    if editCardsModel.communityCards.isEmpty {
                                        Text("No Cards Selected")
                                            .foregroundColor(.gray)
                                    }
                                }
                                .frame(height: 80)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding()
                                .background(Color(UIColor.secondarySystemBackground))
                                .cornerRadius(12)
                            }
                        }

                        
                        NavigationLink(destination: EditCardsView(editCardsModel: editCardsModel)) {
                            Text("Edit Cards")
                                .font(.title3)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.red.opacity(0.8))
                                .cornerRadius(12)
                                .shadow(radius: 4)
                        }
                        .padding(.horizontal, 40)
                    }
                    .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                    
                }
                .navigationTitle("Add New Game")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            print("AddGameView: Cancel pressed, dismissing view.")
                            dismiss()
                        }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save") {
                            print("AddGameView: Save button pressed.")
                            if !canSave {
                                showAlert = true // Show alert if conditions aren't met
                                print("AddGameView: Cannot Save Game.")
                                return
                            }
                            let chips = Int(chipsAmount) ?? 0
                            // Set a positive value for win and a negative value for loss.
                            let chipOutcome = outcome == "Not Played" ? 0 : ( outcome == "Win" ? abs(chips) : -abs(chips) )
                            print("Game outcome: \(outcome)")
                            print("Chip Outcome: \(chipOutcome)")
                            let startingHand = editCardsModel.startingHand
                            let communityCards = editCardsModel.communityCards
                            let newRecord = GameRecord(
                                gameName: gameName.isEmpty ? "New Game" : gameName,
                                gameTime: gameTime,
                                startingHand: startingHand,
                                communityCards: communityCards,
                                status: status,
                                flopDetails: extractFlopDetails(startingHand: startingHand, communityCards: communityCards),
                                chipOutcome: chipOutcome
                            )
                            DataManager.sharedInstance.saveGameRecords(newRecord: newRecord)
                            dismiss()
                        }
                    }
                }
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Not Enough Cards"),
                        message: Text("You must have exactly 2 starting hand cards. If you add community cards, you must include at least 3 cards."),
                        dismissButton: .default(Text("OK"))
                    )
                }
        }
    }
    
    // Returns an array of FlopDetail extracted from the starting hand and community cards.
    func extractFlopDetails(startingHand: [Card], communityCards: [Card]) -> [FlopDetail] {
        var details: [FlopDetail] = []
        
        // Preflop: show starting hand
        if !startingHand.isEmpty {
            details.append(FlopDetail(stage: "Preflop", cards: startingHand, actions: []))
        }
        
        // Flop: first three community cards if available.
        if communityCards.count >= 3 {
            let flopCards = Array(communityCards.prefix(3))
            details.append(FlopDetail(stage: "Flop", cards: flopCards, actions: []))
        }
        
        // Turn: fourth community card if available.
        if communityCards.count >= 4 {
            details.append(FlopDetail(stage: "Turn", cards: [communityCards[3]], actions: []))
        }
        
        // River: fifth community card if available.
        if communityCards.count >= 5 {
            details.append(FlopDetail(stage: "River", cards: [communityCards[4]], actions: []))
        }
        
        return details
    }
}

#Preview {
    AddGameView()
        .environment(EditCardsModel())
}

