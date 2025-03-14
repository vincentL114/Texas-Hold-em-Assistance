//
//  DragCalculatorView.swift
//  Texas Hold'em Assistance
//
//  Created by Vincent on 2/23/25.
//
import SwiftUI

// EditCardsView allows users to modify their card selections.
struct EditCardsView: View {
    /// The model that holds the current state of card selections, including the starting hand, community cards, and the full deck.
    @Bindable var editCardsModel: EditCardsModel
    
    /// An array of suits used to group and display the deck.
    let suits: [String] = ["♠", "♥", "♦", "♣"]
    
    /// Controls the display of an alert for invalid card selections.
    @State private var showAlert = false
    
    /// Holds the message to display when an alert is triggered.
    @State private var alertMessage = ""
    
    var body: some View {
        ScrollView {
            VStack {
                // Drop area for Starting Hand (2 cards)
                VStack(alignment: .leading) {
                    Text("Starting Hand (Click to Remove):")
                        .font(.subheadline)
                    HStack {
                        ForEach(editCardsModel.startingHand) { card in
                            CardView(card: card)
                                .onTapGesture {
                                    removeCard(card)
                                }
                        }
                        Spacer()
                    }
                    .padding()
                    .frame(height: 80)
                    .background(Color.gray)
                    .cornerRadius(10)
                }
                .padding(.horizontal)
                
                // Drop area for Community Cards (up to 5 cards)
                VStack(alignment: .leading) {
                    Text("Community Cards (Click to Remove):")
                        .font(.subheadline)
                    HStack {
                        ForEach(editCardsModel.communityCards) { card in
                            CardView(card: card)
                                .onTapGesture {
                                    removeCard(card)
                                }
                        }
                        Spacer()
                    }
                    .padding()
                    .frame(height: 80)
                    .background(Color.gray)
                    .cornerRadius(10)
                }
                .padding(.horizontal)
                
                Divider()
                    .padding(.vertical)
                
                Text("Tap a card to add it to your hand. If your hand is full, it will be added to community cards.")
                    .font(.headline)
                    .padding(.horizontal, 16)
                
                // Organized deck: display cards grouped by suit.
                VStack(alignment: .leading, spacing: 15) {
                    ForEach(suits, id: \.self) { suit in
                        let suitCards = editCardsModel.deck.filter { $0.suit == suit }
                        ScrollView(.horizontal, showsIndicators: true) {
                            HStack {
                                ForEach(suitCards) { card in
                                    CardView(card: card)
                                        .onTapGesture {
                                            // Only allow selecting a face-up card.
                                            if card.isFaceUp {
                                                addCard(card)
                                            } else {
                                                alertMessage = "\(card.text) is already in play."
                                                showAlert = true
                                            }
                                        }
                                }
                            }
                            .padding(.leading, 10)
                            .padding(.vertical, 5)
                        }
                    }
                }
                
                Spacer()
            }
            .alert("Card Not Available", isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
            .navigationBarTitle("Edit Cards")
            .toolbar {
                // Toolbar button to clear all card selections.
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { clearBoard()}) {
                        Text("Clear")
                            .foregroundColor(.red)
                            .bold()
                    }
                }
            }
            .onDisappear {
                print("User navigated back from Edit Cards")
            }
        }
        .background(Color.color)
    }
    
    // Add a card to starting hand or community cards
    func addCard(_ card: Card) {
        if(editCardsModel.startingHand.count == 2 && editCardsModel.communityCards.count == 5){
            alertMessage = "Community cards are full. You cannot add more than 5 cards."
            print("Alert: \(alertMessage)")
            showAlert = true
            return
        }
        // Find the tapped card in the deck.
        if let index = editCardsModel.deck.firstIndex(where: { $0.id == card.id }) {
            // Flip it (face up to back) with animation.
            withAnimation(.easeInOut(duration: 0.5)) {
                editCardsModel.deck[index].isFaceUp.toggle()
            }
            // After the flip, add a new card copy to the hand and reset its state to face up.
            
            var newCard = editCardsModel.deck[index]
            newCard.isFaceUp = true  // ensure the card appears face up in the hand
            if editCardsModel.startingHand.count < 2 {
                print("Adding card to starting hand: \(newCard.text)")
                editCardsModel.startingHand.append(newCard)
            } else if editCardsModel.communityCards.count < 5 {
                print("Adding card to community cards: \(newCard.text)")
                editCardsModel.communityCards.append(newCard)
            }
        }
    }
    
    
    // Remove a card
    func removeCard(_ card: Card) {
        // Check if the card exists in the starting hand.
        if let _ = editCardsModel.startingHand.firstIndex(where: { $0.id == card.id }) {
            // Find the card in the deck and animate it to face up.
            if let deckIndex = editCardsModel.deck.firstIndex(where: { $0.id == card.id }) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    editCardsModel.deck[deckIndex].isFaceUp = true
                }
            }
            // remove the card from the starting hand.
            print("Removed card from starting hand: \(card.text)")
            editCardsModel.startingHand.removeAll { $0.id == card.id
            }
        }
        // Otherwise, check if the card is in the community cards.
        else if let _ = editCardsModel.communityCards.firstIndex(where: { $0.id == card.id }) {
            if let deckIndex = editCardsModel.deck.firstIndex(where: { $0.id == card.id }) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    editCardsModel.deck[deckIndex].isFaceUp = true
                }
            }
            // remove the card from the community card
            print("Removed card from community cards: \(card.text)")
            editCardsModel.communityCards.removeAll { $0.id == card.id }
            
        }
    }
    
    // Clears all card selections from the starting hand and community cards, and resets the entire deck to be face up.
    func clearBoard(){
        // Clear the starting hand and community cards
        print("Clearing starting hand and community cards.")
        editCardsModel.startingHand.removeAll()
        editCardsModel.communityCards.removeAll()
                    
        // Iterate over the deck and set all cards to face up.
        for index in editCardsModel.deck.indices {
            withAnimation(.easeInOut(duration: 0.5)) {
                editCardsModel.deck[index].isFaceUp = true
            }
        }
    }

}

#Preview {
    EditCardsView(editCardsModel: EditCardsModel())
}
