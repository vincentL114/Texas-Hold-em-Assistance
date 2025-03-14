import SwiftUI

/// CalculatorView displays the user interface for selecting poker cards (starting hand and community cards) and calculating hit probabilities.
struct CalculatorView: View {
    /// Controls whether the probability sheet is shown.
    @State private var showProbabilitySheet = false
    
    /// Controls whether an alert should be displayed
    @State private var showAlert = false
    
    /// Provides access to the shared EditCardsModel which stores the current card selections.
    @Environment(EditCardsModel.self) var editCardsModel
    
    /// Computed property to determine if the probability calculation button should be disabled.
    var isProbabilityButtonDisabled: Bool {
        editCardsModel.startingHand.count != 2 || editCardsModel.communityCards.count < 3
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    
                    Text("Pick your **Starting Hand** and at least **3 Community Cards** to compute hit probabilities.")
                        .font(.title2)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Spacer()
                    
                    // Card Selection Section
                    VStack(spacing: 10) {
                        
                        // Starting Hand Section
                        VStack {
                            Text("Starting Hand")
                                .font(.title)
                                .bold()
                            
                            HStack(spacing: 10) {
                                ForEach(editCardsModel.startingHand) { card in
                                    CardView(card: card)
                                }
                                if editCardsModel.startingHand.isEmpty {
                                    Text("No Cards Selected")
                                        .foregroundColor(.gray)
                                }
                            }
                            .frame(height: 80)
                            .padding()
                            .background(Color.black.opacity(0.5))
                            .cornerRadius(12)
                        }
                        
                        // Community Cards Section
                        VStack {
                            Text("Community Cards")
                                .font(.title)
                                .bold()
                            
                            HStack(spacing: 10) {
                                ForEach(editCardsModel.communityCards) { card in
                                    CardView(card: card)
                                }
                                if editCardsModel.communityCards.isEmpty {
                                    Text("No Cards Selected")
                                        .foregroundColor(.gray)
                                }
                            }
                            .frame(height: 80)
                            .padding()
                            .background(Color.black.opacity(0.5))
                            .cornerRadius(12)
                        }
                    }
                    .padding()
                    
                    // Navigate to the EditCardsView for editing card selections.
                    NavigationLink(destination: EditCardsView(editCardsModel: editCardsModel)) {
                        Text("Edit Cards")
                            .font(.title3)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red.opacity(0.8))
                            .cornerRadius(12)
                            .shadow(radius: 4)
                    }
                    .simultaneousGesture(TapGesture().onEnded {
                        print("CalculatorView: Edit Cards pressed")
                    })
                    .padding(.horizontal, 40)
                    
                    // Probability Button
                    Button(action: {
                        print("Show Hit Probabilities Button pressed")
                        if isProbabilityButtonDisabled {
                            print("Probability calculation disabled: Not enough cards selected.")
                            showAlert = true // Show alert if conditions aren't met
                        } else {
                            print("Launching probability sheet.")
                            showProbabilitySheet.toggle()
                        }
                    }) {
                        Text("Show Hit Probabilities")
                            .font(.title3)
                            .bold()
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(isProbabilityButtonDisabled ? Color.gray : Color.blue)
                            .cornerRadius(12)
                            .shadow(radius: 4)
                    }
                    .padding(.horizontal, 40)
                    .padding(.top, 10)
                    
                    Spacer()
                }
                
                .navigationBarTitle("Hit Calculator")
                .sheet(isPresented: $showProbabilitySheet) {
                    ProbabilitySheetView(model:editCardsModel)
                        .background(Color.color)
                }
                // Alert if not enough cards are selected.
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Not Enough Cards"),
                        message: Text("You must have exactly 2 starting hand cards and at least 3 community cards to calculate Hit probabilities."),
                        dismissButton: .default(Text("OK"))
                    )
                }
            }
            .background(Color.color)
        }
    }
}

#Preview {
    CalculatorView()
        .environment(EditCardsModel())
}

