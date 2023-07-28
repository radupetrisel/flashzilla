//
//  StorageManager.swift
//  Flashzilla
//
//  Created by Radu Petrisel on 28.07.2023.
//

import Foundation

final class StorageManager {
    private init() { }
    
    static func saveCards(_ cards: [Card]) {
        if let jsonData = try? JSONEncoder().encode(cards) {
            try? jsonData.write(to: FileManager.cardsJson, options: [.atomic, .completeFileProtection])
        }
    }
    
    static func loadCards() -> [Card] {
        if let jsonData = try? Data(contentsOf: FileManager.cardsJson) {
            if let cards = try? JSONDecoder().decode([Card].self, from: jsonData) {
                return cards
            }
        }
        
        return []
    }
}

