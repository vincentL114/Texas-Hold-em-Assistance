//
//  HandProbability.swift
//  Texas Hold'em Assistance
//
//  Created by Vincent on 2/23/25.
//

import Foundation

/// The model representing the probability of achieving a specific hand in Texas Hold'em.
struct HandProbability: Identifiable, Codable {
    /// A unique id for the hand probability instance.
    var id = UUID()
    
    /// The name of the hand
    var name: String
    
    /// The probability of achieving this hand
    var probability: String
}
