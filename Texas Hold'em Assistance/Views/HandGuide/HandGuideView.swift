import SwiftUI

struct HandGuideView: View {
    var handGuides: [HandGuideItem] = sampleHandGuides
    
    var body: some View {
        
        NavigationView {
            VStack(spacing: 0) {
                
                // List of hand guides.
                List(handGuides) { guide in
                    VStack(alignment: .leading, spacing: 8) {
                        Text("\(guide.name):")
                            .font(.headline)
                        
                        // Center the cards in each row.
                        HStack(spacing: 8) {
                            ForEach(guide.exampleCards) { card in
                                CardView(card: card)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        
                        Text(guide.description)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 4)
                }
                .scrollContentBackground(.hidden)
                .background(Color.color)
                .navigationTitle("Hand Guide")
            }
        }
    }
}

#Preview {
    HandGuideView()
}
