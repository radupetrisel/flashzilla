//
//  ContentView-ViewModel.swift
//  Flashzilla
//
//  Created by Radu Petrisel on 28.07.2023.
//

import Combine
import SwiftUI

extension ContentView {
    @MainActor final class ViewModel: ObservableObject {
        private let timer = Timer.publish(every: 1, on: .main, in: .common)
        
        private var cancellables = [AnyCancellable]()
        private var isActive = true
        
        @Published private(set) var cards = [Card]()
        @Published private(set) var timeRemaining = 100
        
        init() {
            timer.connect()
                .store(in: &cancellables)
            
            timer.sink { [unowned self] _ in
                guard isActive else { return }
                
                if self.timeRemaining > 0 {
                    self.timeRemaining -= 1
                }
            }
            .store(in: &cancellables)
        }
        
        func updateCard(cardAt index: Int, isCorrect: Bool) {
            guard index >= 0 else { return }
            
            if isCorrect {
                cards.remove(at: index)
                
                if cards.isEmpty {
                    isActive = false
                }
            } else {
                let card = cards.remove(at: index)
                cards.insert(Card(card: card), at: 0)
            }
        }
        
        func updateLastCard(isCorrect: Bool) {
            updateCard(cardAt: cards.count - 1, isCorrect: isCorrect)
        }
        
        func update(scenePhase: ScenePhase) {
            if scenePhase == .active {
                if !cards.isEmpty {
                    isActive = true
                }
            } else {
                isActive = false
            }
        }
        
        
        func resetCards() {
            cards = StorageManager.loadCards()
            timeRemaining = 100
            isActive = true
        }
        
        deinit {
            cancellables.forEach { $0.cancel() }
            cancellables.removeAll()
        }
    }
}
