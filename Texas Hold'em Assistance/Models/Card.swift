//
//  CardModel.swift
//  Texas Hold'em Assistance
//
//  Created by Vincent on 2/23/25.
//
import Foundation

/// Card Model
struct Card: Identifiable, Equatable,Codable {
    /// A unique id for the card instance.
    var id = UUID()
    
    /// The rank of the card (e.g., "A", "K", "Q", "J", "10", etc.).
    let rank: String
    
    /// The suit of the card (e.g., "♠", "♥", "♦", "♣").
    let suit: String
    
    // check if the card is select (selected then turn over)
    var isFaceUp: Bool = true
    
    var text: String {
        let suitLetter: String
        switch suit {
        case "♠":
            suitLetter = "s"
        case "♥":
            suitLetter = "h"
        case "♦":
            suitLetter = "d"
        case "♣":
            suitLetter = "c"
        default:
            suitLetter = suit.lowercased()
        }
        return "\(rank)\(suitLetter)"
    }
}
