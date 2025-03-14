//
//  CardView.swift
//  Texas Hold'em Assistance
//
//  Created by Vincent on 2/23/25.
//

import SwiftUI

/// CardView displays a single playing card.
struct CardView: View {
    /// The card model to be displayed.
    var card: Card
    
    var body: some View {
        ZStack{
            if card.isFaceUp {
                // Displays the card's rank and suit when it is face up.
                Text("\(card.rank) \(card.suit)")
                    .font(.headline)
                    .frame(width: 40, height: 60)
                    .background(Color.white)
                    .foregroundColor(card.suit == "♥" || card.suit == "♦"  ? .red : .black )
                    .cornerRadius(5)
                    .shadow(radius: 3)
                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.black, lineWidth: 1))
            } else {
                // Displays the back of the card using a provided image.
                Image("pokerBack")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 60)
                        .clipped()
                        .cornerRadius(5)
                        .shadow(radius: 3)
                        .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.black, lineWidth: 1))
            }
        }
        // Rotation animation
        .rotation3DEffect(
            .degrees(card.isFaceUp ? 0 : 180),
            axis: (x: 0, y: 1, z: 0)
        )
        .animation(.easeInOut(duration: 0.5), value: card.isFaceUp)
        
    }
}

#Preview {
    HStack{
        CardView(card: Card(rank: "A", suit: "♥",isFaceUp: false))
        CardView(card: Card(rank: "A", suit: "♠", isFaceUp: false))
        CardView(card: Card(rank: "A", suit: "♦"))
        CardView(card: Card(rank: "A", suit: "♣"))
    }
    
}
