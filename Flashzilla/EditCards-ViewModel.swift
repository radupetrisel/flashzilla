//
//  EditCards-ViewModel.swift
//  Flashzilla
//
//  Created by Radu Petrisel on 28.07.2023.
//

import Foundation

extension EditCards {
    @MainActor final class ViewModel: ObservableObject {
        @Published private(set) var cards = [Card]()
        
        func addCard(prompt: String, answer: String) {
            let trimmedPrompt = prompt.trimmingCharacters(in: .whitespaces)
            let trimmerAnswer = answer.trimmingCharacters(in: .whitespaces)
            
            guard !trimmedPrompt.isEmpty && !trimmerAnswer.isEmpty else { return }
            
            let card = Card(prompt: trimmedPrompt, answer: trimmerAnswer)
            cards.insert(card, at: 0)
            
            StorageManager.saveCards(cards)
        }
        
        func removeCards(atOffsets offsets: IndexSet) {
            cards.remove(atOffsets: offsets)
            StorageManager.saveCards(cards)
        }
        
        func loadCards() {
            cards = StorageManager.loadCards()
        }
    }
}
