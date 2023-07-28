//
//  EditCards.swift
//  Flashzilla
//
//  Created by Radu Petrisel on 27.07.2023.
//

import SwiftUI

struct EditCards: View {
    @Environment(\.dismiss) private var dismiss
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
                loadCards()
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
        
        saveCards()
        
        prompt = ""
        answer = ""
    }
    
    private func remove(atOffsets offsets: IndexSet) {
        cards.remove(atOffsets: offsets)
        saveCards()
    }
    
    private func done() {
        dismiss()
    }
    
    private func saveCards() {
        if let jsonData = try? JSONEncoder().encode(cards) {
            try? jsonData.write(to: FileManager.cardsJson)
        }
    }
    
    private func loadCards() {
        if let jsonData = try? Data(contentsOf: FileManager.cardsJson) {
            if let cards = try? JSONDecoder().decode([Card].self, from: jsonData) {
                self.cards = cards
            }
        }
    }
}

struct EditCards_Previews: PreviewProvider {
    static var previews: some View {
        EditCards()
    }
}
