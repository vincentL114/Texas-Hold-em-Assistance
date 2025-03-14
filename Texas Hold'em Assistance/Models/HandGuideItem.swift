//
//  HandGuideItems.swift
//  Texas Hold'em Assistance
//
//  Created by Vincent on 2/23/25.
//
import Foundation

/// The  model representing a guide item for a specific poker hand.
struct HandGuideItem: Identifiable {
    let id = UUID()
    let name: String
    let exampleCards: [Card]
    let description: String
}

// Example data for the hand guide.
let sampleHandGuides: [HandGuideItem] = [
    HandGuideItem(
        name: "High Card",
        exampleCards: [
            Card(rank: "A", suit: "♣"),
            Card(rank: "7", suit: "♦"),
            Card(rank: "4", suit: "♠"),
            Card(rank: "9", suit: "♥"),
            Card(rank: "3", suit: "♣")
        ],
        description: "No matching cards. The highest card wins."
    ),
    HandGuideItem(
        name: "One Pair",
        exampleCards: [
            Card(rank: "K", suit: "♠"),
            Card(rank: "K", suit: "♦"),
            Card(rank: "8", suit: "♣"),
            Card(rank: "5", suit: "♥"),
            Card(rank: "2", suit: "♠")
        ],
        description: "Two cards of the same rank form a pair."
    ),
    HandGuideItem(
        name: "Two Pair",
        exampleCards: [
            Card(rank: "Q", suit: "♥"),
            Card(rank: "Q", suit: "♣"),
            Card(rank: "J", suit: "♦"),
            Card(rank: "J", suit: "♠"),
            Card(rank: "7", suit: "♣")
        ],
        description: "Two different pairs of cards."
    ),
    HandGuideItem(
        name: "Three of a Kind",
        exampleCards: [
            Card(rank: "T", suit: "♠"),
            Card(rank: "T", suit: "♦"),
            Card(rank: "T", suit: "♣"),
            Card(rank: "8", suit: "♥"),
            Card(rank: "3", suit: "♠")
        ],
        description: "Three cards of the same rank."
    ),
    HandGuideItem(
        name: "Straight",
        exampleCards: [
            Card(rank: "7", suit: "♣"),
            Card(rank: "8", suit: "♠"),
            Card(rank: "9", suit: "♦"),
            Card(rank: "T", suit: "♥"),
            Card(rank: "J", suit: "♣")
        ],
        description: "Five cards in numerical order of any suit."
    ),
    HandGuideItem(
        name: "Flush",
        exampleCards: [
            Card(rank: "2", suit: "♥"),
            Card(rank: "6", suit: "♥"),
            Card(rank: "9", suit: "♥"),
            Card(rank: "J", suit: "♥"),
            Card(rank: "K", suit: "♥")
        ],
        description: "Five cards of the same suit, not in order."
    ),
    HandGuideItem(
        name: "Full House",
        exampleCards: [
            Card(rank: "Q", suit: "♣"),
            Card(rank: "Q", suit: "♦"),
            Card(rank: "Q", suit: "♠"),
            Card(rank: "8", suit: "♣"),
            Card(rank: "8", suit: "♥")
        ],
        description: "Three cards of one rank and two cards of another."
    ),
    HandGuideItem(
        name: "Four of a Kind",
        exampleCards: [
            Card(rank: "J", suit: "♠"),
            Card(rank: "J", suit: "♦"),
            Card(rank: "J", suit: "♣"),
            Card(rank: "J", suit: "♥"),
            Card(rank: "5", suit: "♣")
        ],
        description: "All four cards of the same rank."
    ),
    HandGuideItem(
        name: "Straight Flush",
        exampleCards: [
            Card(rank: "8", suit: "♠"),
            Card(rank: "9", suit: "♠"),
            Card(rank: "T", suit: "♠"),
            Card(rank: "J", suit: "♠"),
            Card(rank: "Q", suit: "♠")
        ],
        description: "Five cards in sequence, all of the same suit."
    ),
    HandGuideItem(
        name: "Royal Flush",
        exampleCards: [
            Card(rank: "T", suit: "♥"),
            Card(rank: "J", suit: "♥"),
            Card(rank: "Q", suit: "♥"),
            Card(rank: "K", suit: "♥"),
            Card(rank: "A", suit: "♥")
        ],
        description: "The highest straight flush, from 10 to Ace."
    )
]
