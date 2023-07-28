//
//  Card.swift
//  Flashzilla
//
//  Created by Radu Petrisel on 27.07.2023.
//

import Foundation

struct Card: Identifiable, Codable {
    let id = UUID()
    let prompt: String
    let answer: String
    
    static let preview = Card(prompt: "Who player the 13th Doctor Who in \"Doctor Who\"?", answer: "Jodie Whittaker")
    
    enum CodingKeys: CodingKey {
        case prompt
        case answer
    }
}

extension Card {
    init(card: Card) {
        self.prompt = card.prompt
        self.answer = card.answer
    }
}
