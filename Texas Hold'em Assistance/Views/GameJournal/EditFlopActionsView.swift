//
//  EditFlopActionsView.swift
//  Texas Hold'em Assistance
//
//  Created by Vincent on 3/8/25.
//

import SwiftUI

/// EditFlopActionsView provides an editable  interface for modifying the actions
struct EditFlopActionsView: View {
    // A binding to a FlopDetail object that holds the stage's cards and associated actions.
    @Binding var flopDetail: FlopDetail
    
    // Estimated height for each row in the list. Adjust this value if your row design changes.
    private let estimatedRowHeight: CGFloat = 44
    
    // Compute the height dynamically
    private var listHeight: CGFloat {
        // Ensure a minimum height of one row so that an empty list still shows something
        CGFloat(flopDetail.actions.count) * estimatedRowHeight
    }
        
    var body: some View {
        VStack(alignment: .leading) {
            // Displays the list of actions for the current stage.
            List {
                ForEach($flopDetail.actions) { $action in
                    HStack {
                        // Picker for selecting the type of action
                        Picker("Action", selection: $action.type) {
                            ForEach(PokerActionType.allCases, id: \.self) { type in
                                Text(type.rawValue.capitalized).tag(type)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        
                        // Binding between the Int chip amount and its String representation.
                        let amountBinding = Binding<String>(
                            get: { String(action.amount) },
                            set: { newValue in
                                // If newValue is empty, treat it as zero.
                                if newValue.isEmpty {
                                    action.amount = 0
                                } else if let intValue = Int(newValue) {
                                    action.amount = intValue
                                }
                                // Optionally, you can add further validation for maximum digits, etc.
                            }
                        )
                        
                        TextField("Amount", text: amountBinding)
                            .keyboardType(.numberPad)
                    }
                    // Adjust row insets (left/right padding around each row)
                    .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                }
                .onDelete { indexSet in
                    print("Deleting actions at offsets: \(indexSet)")
                    flopDetail.actions.remove(atOffsets: indexSet)
                }
            }
            .listStyle(.plain)                  // Removes extra insets and default styling
            .listRowSeparator(.hidden)         // Hides the horizontal row separators
            .scrollContentBackground(.hidden)
            .frame(height: listHeight)
            
            // Button to add a new default action.
            Button(action: {
                let newAction = PokerAction(type: .raise, amount: 0)
                print("Adding new action")
                flopDetail.actions.append(newAction)
            }) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Add Action")
                }
            }
        }
    }
}

#Preview {
    EditFlopActionsView(flopDetail: .constant(FlopDetail(
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
        )))
}
