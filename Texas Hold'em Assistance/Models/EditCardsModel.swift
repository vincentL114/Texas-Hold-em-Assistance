//
//  CalculatorModel.swift
//  Texas Hold'em Assistance
//
//  Created by Vincent on 2/23/25.
//

import Foundation

/// The model that stores and manages the player's starting hand, community cards, and the full deck of cards.
@Observable
class EditCardsModel {
    /// Holds up to  two cards that make up the player's starting hand.
    var startingHand: [Card] = []
    
    /// Holds the community cards (up to 5 cards: flop, turn, river) that are shared by all players.
    var communityCards: [Card] = []
    
    /// The full deck of cards.
    var deck: [Card] = {
        let ranks = ["A", "K", "Q", "J", "T", "9", "8", "7", "6", "5", "4", "3", "2"]
        let suits = ["♠", "♥", "♦", "♣"]
        var cards = [Card]()
        for suit in suits {
            for rank in ranks {
                cards.append(Card(rank: rank, suit: suit))
            }
        }
        return cards
    }()
    
}
