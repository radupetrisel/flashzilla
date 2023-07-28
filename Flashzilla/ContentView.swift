//
//  ContentView.swift
//  Flashzilla
//
//  Created by Radu Petrisel on 26.07.2023.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.accessibilityDifferentiateWithoutColor) private var differentiateWithoutColor
    @Environment(\.accessibilityVoiceOverEnabled) private var voiceOverEnabled
    
    @EnvironmentObject private var storageManager: StorageManager
    
    @State private var cards = [Card]()
    @State private var timeRemaning = 100
    @State private var isActive = true
    @State private var isShowingEditScreen = false
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                Text("\(timeRemaning)")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 5)
                    .background(.black.opacity(0.75))
                    .clipShape(Capsule())
                
                ZStack {
                    ForEach(cards) { card in
                        let index = cards.firstIndex { $0.id == card.id }!
                        
                        CardView(card: card) { isCorrect in
                            withAnimation {
                                onSwiped(cardAt: index, isCorrect: isCorrect)
                            }
                        }
                        .stacked(at: index, in: cards.count)
                        .allowsTightening(index == cards.count - 1)
                        .accessibilityHidden(index < cards.count - 1)
                    }
                }
                .allowsHitTesting(timeRemaning > 0)
                
                if cards.isEmpty {
                    Button("Start again", action: resetCards)
                        .padding()
                        .background(.white)
                        .foregroundColor(.black)
                        .clipShape(Capsule())
                }
            }
            
            VStack {
                HStack {
                    Spacer()
                    
                    Button {
                        isShowingEditScreen = true
                    } label: {
                        Image(systemName: "plus.circle")
                            .padding()
                            .background(.black.opacity(0.7))
                            .clipShape(Circle())
                    }
                }
                
                Spacer()
            }
            .foregroundColor(.white)
            .padding()
            
            if differentiateWithoutColor || voiceOverEnabled {
                VStack {
                    Spacer()
                    HStack {
                        Button {
                            withAnimation {
                                onSwiped(cardAt: cards.count - 1, isCorrect: false)
                            }
                        } label: {
                            Image(systemName: "xmark.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(Circle())
                        }
                        .accessibilityLabel("Wrong")
                        .accessibilityHint("Mark your answer as being wrong")
                        
                        Spacer()
                        
                        Button {
                            withAnimation {
                                onSwiped(cardAt: cards.count - 1, isCorrect: true)
                            }
                        } label: {
                            Image(systemName: "checkmark.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(Circle())
                        }
                        .accessibilityLabel("Correct")
                        .accessibilityHint("Mark your answer as being correct")
                    }
                    .foregroundColor(.white)
                    .font(.title)
                    .padding()
                }
            }
        }
        .onReceive(timer) { _ in
            guard isActive else { return }
            
            if timeRemaning > 0 {
                timeRemaning -= 1
            }
        }
        .onChange(of: scenePhase) { newValue in
            if newValue == .active {
                if !cards.isEmpty {
                    isActive = true
                }
            } else {
                isActive = false
            }
        }
        .sheet(isPresented: $isShowingEditScreen, onDismiss: resetCards, content: EditCards.init)
        .onAppear(perform: resetCards)
    }
    
    private func onSwiped(cardAt index: Int, isCorrect: Bool) {
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
    
    private func resetCards() {
        cards = storageManager.loadCards()
        timeRemaning = 100
        isActive = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension View {
    func stacked(at position: Int, in total: Int) -> some View {
        let offset = Double(total - position)
        
        return self.offset(x: 0, y: offset * 10)
    }
}
