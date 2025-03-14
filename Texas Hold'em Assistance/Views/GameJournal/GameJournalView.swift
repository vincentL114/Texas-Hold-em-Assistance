//
//  Untitled.swift
//  Texas Hold'em Assistance
//
//  Created by Vincent on 3/6/25.
//
import SwiftUI

/// GameJournalView displays an overview of game records, including overall statistics
struct GameJournalView: View {
    // Holds the game records loaded from UserDefaults.
    @State private var gameRecords: [GameRecord] = []
    
    // Controls whether the AddGameView sheet is displayed.
    @State private var showAddGame = false
    
    // Computed property that calculates the participation rate.
    var participationRate: Double {
        let total = gameRecords.count
        guard total > 0 else { return 0 }
        let participated = gameRecords.filter { $0.status != "not played" }.count
        return (Double(participated) / Double(total)) * 100.0
    }
    
    // Computed property that calculates the win rate among played games.
    var winRate: Double {
        let participated = gameRecords.filter { $0.status != "not played" }
        guard participated.count > 0 else { return 0 }
        let wins = participated.filter { $0.status == "win" }.count
        return (Double(wins) / Double(participated.count)) * 100.0
    }
    
    // Computes the total chips won across all games.
    var totalChipsWon: Int {
        gameRecords.filter { $0.chipOutcome > 0 }
                   .map { $0.chipOutcome }
                   .reduce(0, +)
    }
    
    // Computes the total chips lost across all games.
    var totalChipsLost: Int {
        gameRecords.filter { $0.chipOutcome < 0 }
                   .map { abs($0.chipOutcome) }
                   .reduce(0, +)
    }

    // Computes the net chips by subtracting total losses from total wins.
    var netChips: Int { totalChipsWon - totalChipsLost }
    
    var body: some View {
        NavigationView {
            VStack {
                // Top panel with overall statistics.
                VStack {
                    HStack {
                        VStack {
                            Text("Participation Rate")
                                .font(.subheadline)
                            Text("\(participationRate, specifier: "%.1f")%")
                                .font(.headline)
                        }
                        .padding()
                        Spacer()
                        VStack {
                            Text("Win Rate")
                                .font(.subheadline)
                            Text("\(winRate, specifier: "%.1f")%")
                                .font(.headline)
                        }
                        .padding()
                        Spacer()
                        VStack {
                            Text("Game Count")
                                .font(.subheadline)
                            Text("\(gameRecords.count)")
                                .font(.headline)
                        }
                        .padding()
                    }
                    HStack {
                        VStack {
                            Text("Total Win")
                                .font(.subheadline)
                            Text("$\(totalChipsWon)")
                                .font(.headline)
                        }
                        .padding()
                        Spacer()
                        VStack {
                            Text("Total Loss")
                                .font(.subheadline)
                            Text("$\(totalChipsLost)")
                                .font(.headline)
                        }
                        .padding()
                        Spacer()
                        VStack {
                            Text("Net")
                                .font(.subheadline)
                            Text("$\(netChips)")
                                .font(.headline)
                                .foregroundColor(netChips >= 0 ? Color("lightGreen") : .red)
                        }
                        .padding()
                    }
                    .padding(.horizontal)
                }
                
                Text("Game Records")
                    .font(.largeTitle)
                    .padding(.top)
                    .bold()

                ZStack {
                    Color(uiColor: .systemGray6)
                            .edgesIgnoringSafeArea(.all)
                        
                    if gameRecords.isEmpty {
                        // If empty, show your “no records” message
                        VStack(spacing: 8) {
                            Text("No game records available.")
                                .font(.title2)
                                .bold()
                                .foregroundColor(.gray)
                            
                            Text("Add a new one now!")
                                .font(.title3)
                                .foregroundColor(.gray)
                        }
                    } else {
                        // Otherwise, show the list
                        List {
                            ForEach(gameRecords) { record in
                                GameRecordRow(record: record)
                            }
                            .onDelete(perform: deleteGameRecord)
                            .onMove(perform:moveGameRecord)
                        }
                    }
                }
            }
            .navigationTitle("Game Journal")
            .background(Color.color)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    // The built-in EditButton toggles edit mode for the list.
                    EditButton()
                        .simultaneousGesture(TapGesture().onEnded {
                            print("AddGameView: EditButton pressed")
                        })
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        print("GameJournalView: Plus button pressed. Presenting AddGameView.")
                        showAddGame = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddGame, onDismiss: {
                print("GameJournalView: AddGameView dismissed. Reloading game records.")
                // Reload game records from UserDefaults when AddGameView is dismissed.
                loadGameRecords()
            })  {
                AddGameView()
            }
            .onAppear {
                // Load game records from UserDefaults
                loadGameRecords()
            }
        
           
        }
    }
    
    // Loads game records from UserDefault using DataManager and updates the local state.
    func loadGameRecords(){
        gameRecords = DataManager.sharedInstance.loadGameRecords()
    }
    
    // Moves a game record from one position to another in both the local data and User Default
    func moveGameRecord(from source: IndexSet, to destination: Int){
        gameRecords.move(fromOffsets: source, toOffset: destination)
        DataManager.sharedInstance.moveGameRecords(from: source, to: destination)
    }
    
    // Deletes game records at the specified offsets both locally and from User Default
    func deleteGameRecord(at offsets: IndexSet){
        gameRecords.remove(atOffsets: offsets)
        DataManager.sharedInstance.deleteGameRecords(at:offsets)
    }
}

#Preview {
    GameJournalView()
        .environment(EditCardsModel())
}
