import SwiftUI

// ProbabilitySheetView displays the calculated hit probabilities for a given hand.
struct ProbabilitySheetView: View {
    // Environment dismiss function used to close the sheet.
    @Environment(\.dismiss) var dismiss
    
    // Holds the array of calculated hit probabilities retrieved from the API.
    @State private var handProbabilities: [HandProbability] = []
    
    // The model holding the card selections, including the starting hand and community cards.
    @Bindable var model: EditCardsModel
    
    // Control whether the loading spinner should be displayed
    @State private var isLoading = false
    
    // Controls whether an alert should be displayed
    @State private var showAlert = false
    
    // Alert Message
    @State private var alertMessage = ""
    
    // Computes and returns a sorted array of HandProbability objects,
    // sorted in descending order based on the probability percentage.
    var sortedProbabilities: [HandProbability] {
        handProbabilities.sorted { first, second in
            let firstValue = Double(first.probability.replacingOccurrences(of: "%", with: "")) ?? 0.0
            let secondValue = Double(second.probability.replacingOccurrences(of: "%", with: "")) ?? 0.0
            return firstValue > secondValue
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment:.leading){
                HStack {
                    // Starting Hand display
                    Text("Starting Hand:        ")
                        .font(.headline)
                    // Community Cards display
                    HStack(spacing: 8) {
                        ForEach(model.startingHand) { card in
                            CardView(card: card)
                        }
                    }
                }
                .padding(.leading, 5)
                HStack {
                    Text("Community Cards:")
                        .font(.headline)
                    HStack(spacing: 8) {
                        ForEach(model.communityCards) { card in
                            CardView(card: card)
                        }
                    }
                }
                .padding(.leading, 5)
                Divider()
                if isLoading {
                    // Loading animation in the center if no data is available yet.
                    VStack {
                        ProgressView("Calculating...")
                            .progressViewStyle(CircularProgressViewStyle())
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(UIColor.systemBackground))
                } else {
                    // Otherwise, show the sorted list of hit probabilities.
                    List(sortedProbabilities) { hand in
                        HStack {
                            Text(hand.name)
                                .font(.headline)
                            Spacer()
                            Text(hand.probability)
                                .font(.subheadline)
                        }
                    }
                }
            }
            .navigationTitle("Hit Probabilities")
            .toolbar {
                // Toolbar item to allow the user to close the sheet.
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        print("ProbabilitySheetView: Close button pressed, dismissing view.")
                        dismiss()
                    }
                }
            }
            .onAppear {
                isLoading = true
                fetchPokerOdds(for: model) { result in
                    DispatchQueue.main.async {
                        isLoading = false
                        switch result {
                        case .success(let odds):
                            print("ProbabilitySheetView: Successfully fetched odds: \(odds)")
                            self.handProbabilities = odds
                        case .failure(let error):
                            alertMessage = error.localizedDescription
                            showAlert = true
                            print("Error fetching odds: \(error)")
                        }
                    }
                }
            }
            .alert(isPresented: $showAlert) {
                print("ProbabilitySheetView: Alert")
                return Alert(title: Text("Network Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    // Dummy simulation function that returns sample hand probabilities.
    // In the production version, this function would call an API to calculate the probabilities.
    func fetchPokerOdds(for model: EditCardsModel, completion: @escaping (Result<[HandProbability], Error>) -> Void) {
        let sampleOdds =  [
            HandProbability(name: "High Card", probability: "30%"),
            HandProbability(name: "Pair", probability: "40%"),
            HandProbability(name: "Two Pair", probability: "20%"),
            HandProbability(name: "Three of a Kind", probability: "5%"),
            HandProbability(name: "Straight", probability: "3%"),
            HandProbability(name: "Flush", probability: "1%"),
            HandProbability(name: "Full House", probability: "0.5%"),
            HandProbability(name: "Four of a Kind", probability: "0.4%"),
            HandProbability(name: "Straight Flush", probability: "0.09%"),
            HandProbability(name: "Royal Flush", probability: "0.01%")
        ]
        completion(.success(sampleOdds))
    }
    

}

#Preview {
    let dummyModel = EditCardsModel()
    dummyModel.startingHand = [Card(rank: "A", suit: "♠"), Card(rank: "K", suit: "♠")]
    dummyModel.communityCards = [Card(rank: "A", suit: "♥"), Card(rank: "J", suit: "♠"), Card(rank: "T", suit: "♠"),Card(rank: "A", suit: "♣"),Card(rank: "A", suit: "♦")]
    return ProbabilitySheetView(model: dummyModel)
}
