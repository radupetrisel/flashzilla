//
//  EditCards.swift
//  Flashzilla
//
//  Created by Radu Petrisel on 27.07.2023.
//

import SwiftUI

struct EditCards: View {
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var viewModel = ViewModel()
    
    @State private var prompt = ""
    @State private var answer = ""
    
    var body: some View {
        NavigationView {
            List {
                Section("Add new card") {
                    TextField("Prompt", text: $prompt)
                    TextField("Answer", text: $answer)
                    
                    Button(action: addCard) {
                        Label("Add", systemImage: "plus.circle")
                    }
                }
                
                Section("All cards") {
                    ForEach(viewModel.cards) { card in
                        VStack(alignment: .leading) {
                            Text(card.prompt)
                                .font(.title)
                            
                            Text(card.answer)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .onDelete(perform: { viewModel.removeCards(atOffsets: $0) })
                }
            }
            .toolbar {
                Button("Done", action: done)
            }
            .onAppear {
                viewModel.loadCards()
            }
        }
    }
    
    private func addCard() {
        withAnimation {
            viewModel.addCard(prompt: prompt, answer: answer)
        }
        
        prompt = ""
        answer = ""
    }
    
    private func done() {
        dismiss()
    }
}

struct EditCards_Previews: PreviewProvider {
    static var previews: some View {
        EditCards()
    }
}
