//
//  EditGameView.swift
//  Texas Hold'em Assistance
//
//  Created by Vincent on 3/8/25.
//

import SwiftUI

/// EditGameView provides an interface for modifying an existing game record.
struct EditGameView: View {
    // Environment dismiss action to close the view.
    @Environment(\.dismiss) var dismiss
   
    // A binding to the GameRecord being edited.
    @Binding var gameRecord: GameRecord
    
    // Holds the chip amount as a string so that it can be edited in a TextField.
    @State private var chipsAmount: String
    
    // Custom initializer to create an instance of EditGameView.
    init(gameRecord: Binding<GameRecord>) {
        _gameRecord = gameRecord
        // Convert chipOutcome Int to String
        _chipsAmount = State(initialValue: String(gameRecord.wrappedValue.chipOutcome))
    }
    
    // A computed property that determines the outcome label based on the game status.
    private var outcome: String {
        // If status is "fold" or "loss," outcome is "loss." Otherwise, it's "win."
        gameRecord.status == "not played" ? "Not Played" : (gameRecord.status == "fold" || gameRecord.status == "loss" ? "Loss" : "Win")
    }
    
    // List of possible statuses for the game.
    let statuses = ["win", "fold", "loss","not played"]
    
    var body: some View {
        NavigationView {
            // Game Info Form
            Form {
                Section(header: Text("Game Info")) {
                    // TextField for editing the game name.
                    TextField("Game Name", text: $gameRecord.gameName)
                    
                    // Segmented Picker for selecting the game status.
                    VStack(alignment: .leading, spacing: 16) {
                        Picker("Status", selection: $gameRecord.status) {
                            ForEach(statuses, id: \.self) { stat in
                                Text(stat.capitalized).tag(stat)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        
                        // HStack for chip amount input and outcome label.
                        HStack {
                            TextField("Enter \(outcome.capitalized) Chips", text: gameRecord.status == "not played" ? .constant("0") : $chipsAmount)
                                .keyboardType(.numberPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .disabled(gameRecord.status == "not played")
                            
                            // Outcome label based on status
                            Text(outcome.capitalized)
                                .padding(.leading, 8)
                                .foregroundColor(gameRecord.status == "not played" ? .gray : (gameRecord.status == "fold" || gameRecord.status == "loss" ? .red : .green))
                        }
                    }
                    
                    // DatePicker for selecting the game time.
                    DatePicker("Game Time", selection: $gameRecord.gameTime, displayedComponents: [.date, .hourAndMinute])
                }
                
                // Flop Details Section
                Section(header: Text("Flop Details")) {
                    ForEach($gameRecord.flopDetails) { $detail in
                        VStack(alignment: .leading, spacing: 8) {
                            // Display the stage name.
                            Text(detail.stage)
                                .font(.headline)
                            
                            // Display the cards associated with the current stage.
                            HStack {
                                ForEach(detail.cards) { card in
                                    CardView(card: card)
                                }
                            }
                            
                            // Editable actions table.
                            EditFlopActionsView(flopDetail: $detail)
                        }
                        .padding(.vertical, 8)
                    }
                }
            }
            .navigationTitle("Edit")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        print("EditGameView: Cancel button pressed. Dismissing view.")
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save"){
                        print("EditGameView: Save Button pressed")
                        let chips = Int(chipsAmount) ?? 0
                        // Set a positive value for win and a negative value for loss.
                        let chipOutcome = outcome == "Not Played" ? 0 : ( outcome == "Win" ? abs(chips) : -abs(chips) )
                        print("Game outcome: \(outcome)")
                        print("Chip Outcome: \(chipOutcome)")
                        gameRecord.chipOutcome = chipOutcome
                        DataManager.sharedInstance.updateGameRecord(updatedRecord: gameRecord)
                        dismiss()
                    }
                }
            }
        }
    }

}

#Preview {
    EditGameView(gameRecord: .constant(
        GameRecord(gameName: "Game 1",
                   gameTime: Date(),
                   startingHand: [
                        Card(rank: "A", suit: "♠"),
                        Card(rank: "K", suit: "♠")
                   ],
                   communityCards: [
                        Card(rank: "Q", suit: "♥"),
                        Card(rank: "J", suit: "♥"),
                        Card(rank: "10", suit: "♥")
                   ],
                   status: "win",
                   flopDetails: [
                        FlopDetail(
                            stage: "Flop",
                            cards: [
                                Card(rank: "Q", suit: "♥"),
                                Card(rank: "J", suit: "♥"),
                                Card(rank: "10", suit: "♥")
                            ],
                            actions: [
                                PokerAction(type: .raise, amount: 2000),
                                PokerAction(type: .call, amount: 3000)
                            ]
                        ),
                        FlopDetail(
                            stage: "Turn",
                            cards: [
                                Card(rank: "3", suit: "♦")
                            ],
                            actions: [
                                PokerAction(type: .check, amount: 0)
                            ]
                        ),
                        FlopDetail(
                            stage: "River",
                            cards: [
                                Card(rank: "2", suit: "♣")
                            ],
                            actions: [
                                PokerAction(type: .bet, amount: 1000)
                            ]
                        )
                   ],
                   chipOutcome: 150
        )
    ))
}

