//
//  Untitled.swift
//  Texas Hold'em Assistance
//
//  Created by Vincent on 3/6/25.
//
import SwiftUI

/// GameDetailView displays detailed information for a given game record.
struct GameDetailView: View {
    // Holds the current game record being displayed.
    @State var gameRecord: GameRecord
    
    // Controls whether the EditGameView is presented.
    @State private var showEditGame = false
    
    var body: some View {
            VStack(alignment: .leading, spacing: 16) {
                // Display the starting hand as CardViews.
                HStack {
                    Text("Starting Hand:        ")
                        .bold()
                    ForEach(gameRecord.startingHand) { card in
                        CardView(card: card)
                    }
                }
                
                // Display community cards if available.
                if !gameRecord.communityCards.isEmpty {
                    HStack {
                        Text("Community Cards: ")
                            .bold()
                        ForEach(gameRecord.communityCards) { card in
                            CardView(card: card)
                        }
                    }
                }
                HStack {
                    Text("Chip Outcome:")
                        .bold()
                    Text("\(gameRecord.chipOutcome)")
                        .foregroundColor(gameRecord.status == "win" ? Color("lightGreen"): (gameRecord.status == "not played" ? Color("notPlayed") : .red ))
                }
                HStack {
                    Text("Status:")
                        .bold()
                    Text("\(gameRecord.status.capitalized)")
                        .font(.headline)
                        .foregroundColor(gameRecord.status == "win" ? Color("lightGreen"): (gameRecord.status == "not played" ? Color("notPlayed") : .red ))
                }
                
                Text("Game Details")
                    .bold()
                    .font(.title2)
                    .padding(.vertical, 8)
                
                // For each stage, display the cards as CardViews and the actions.
                List(gameRecord.flopDetails) { detail in
                    VStack(alignment: .leading) {
                        Text(detail.stage)
                            .font(.headline)
                        HStack {
                            ForEach(detail.cards) { card in
                                CardView(card: card)
                            }
                            Spacer()
                            Text("\(detail.actionsDescription)")
                                .foregroundColor(.blue)
                        }
                        .font(.subheadline)
                    }
                    .padding(.vertical, 4)
                }
            }
            .padding(.horizontal)
            .background(Color.color)
            .navigationTitle("\(gameRecord.gameName)")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showEditGame = true
                        print("GameDetailView: Edit button pressed. Presenting EditGameView.")
                    }) {
                        Text("Edit")
                    }
                }
            }
            .sheet(isPresented: $showEditGame)  {
                EditGameView(gameRecord: $gameRecord)
            }
        }
    }

#Preview {
    GameDetailView(gameRecord:
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
                      status: "not played",
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
                      ))
}

