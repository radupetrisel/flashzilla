//
//  EditCards.swift
//  Flashzilla
//
//  Created by Radu Petrisel on 27.07.2023.
//

import SwiftUI

struct EditCards: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var storageManager: StorageManager
    
    @State private var cards = [Card]()
    
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
                    ForEach(cards) { card in
                        VStack(alignment: .leading) {
                            Text(card.prompt)
                                .font(.title)
                            
                            Text(card.answer)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .onDelete(perform: remove(atOffsets:))
                }
            }
            .toolbar {
                Button("Done", action: done)
            }
            .onAppear {
                cards = storageManager.loadCards()
            }
        }
    }
    
    private func addCard() {
        let trimmedPrompt = prompt.trimmingCharacters(in: .whitespaces)
        let trimmerAnswer = answer.trimmingCharacters(in: .whitespaces)
        
        guard !trimmedPrompt.isEmpty && !trimmerAnswer.isEmpty else { return }
        
        let card = Card(prompt: trimmedPrompt, answer: trimmerAnswer)
        withAnimation {
            cards.insert(card, at: 0)
        }
        
        storageManager.saveCards(cards)
        
        prompt = ""
        answer = ""
    }
    
    private func remove(atOffsets offsets: IndexSet) {
        cards.remove(atOffsets: offsets)
        storageManager.saveCards(cards)
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
