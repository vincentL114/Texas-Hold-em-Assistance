//
//  GameRecordRow.swift
//  Texas Hold'em Assistance
//
//  Created by Vincent on 3/7/25.
//
import SwiftUI

// GameRecordRow displays a single row for a game record in the Game Journal.
struct GameRecordRow: View {
    // The game record to display in this row.
    let record: GameRecord
    
    var body: some View {
        // NavigationLink enables navigation to the GameDetailView when the row is tapped.
        NavigationLink(destination: GameDetailView(gameRecord: record)) {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(record.gameName)
                        .font(.headline)
                    Spacer()
                    Text(record.formattedTime)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                HStack {
                    ForEach(record.startingHand) { card in
                        CardView(card: card)
                    }
                    Spacer()
                    Text("\(record.status.capitalized) $\(record.chipOutcome)")
                        .font(.title2)
                        .foregroundColor(record.status == "win" ? .green : (record.status == "not played" ? .gray : .red))
                        .padding(.trailing, 20)
                }
            }
            .padding(.vertical, 4)
        }
    }
    
}

#Preview{
    GameRecordRow(record: GameRecord(
        gameName: "Game 1",
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
        chipOutcome: 50
    ))
}
           
