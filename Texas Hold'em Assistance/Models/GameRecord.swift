//
//  GameRecord.swift
//  Texas Hold'em Assistance
//
//  Created by Vincent on 3/6/25.
//

import Foundation

struct GameRecord: Identifiable,Codable{
    var id = UUID()
    var gameName: String
    var gameTime: Date
    let startingHand: [Card]       // Displayed using CardView
    let communityCards: [Card]     // Displayed using CardView
    var status: String             // "win", "fold","loss" or "not played"
    var flopDetails: [FlopDetail]  // Detailed stage info
    var chipOutcome: Int
    
    /// A computed property that returns a formatted string of the gameTime,
    /// including both the date and time.
    var formattedTime: String {
        return GameRecord.dateFormatter.string(from: gameTime)
    }
    
    /// A static DateFormatter to be reused for formatting gameTime.
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short    
        return formatter
    }()
}

/// Enum for common poker actions.
enum PokerActionType: String, Codable, CaseIterable {
    case smallBlind, bigBlind, raise, call, fold, check, bet, allIn
}

/// A model representing a single poker action with an associated amount.
struct PokerAction: Identifiable, Codable{
    var id = UUID()
    var type: PokerActionType
    var amount: Int
}

/// FlopDetail now holds an array of PokerAction instead of a single string.
struct FlopDetail: Identifiable,Codable {
    var id = UUID()
    let stage: String    // e.g., "Preflop","Flop", "Turn", "River"
    let cards: [Card]    // Displayed using CardView
    var actions: [PokerAction]
    
    /// A computed property that returns a formatted description of all actions.
    var actionsDescription: String {
        actions.map { "\($0.type.rawValue.capitalized) \($0.amount)" }
               .joined(separator: ", ")
    }
}
