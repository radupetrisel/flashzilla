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
    
    @StateObject var viewModel = ViewModel()
    @State private var isShowingEditScreen = false

    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                timeCapsule()
                
                ZStack {
                    ForEach(viewModel.cards) { card in
                        let index = viewModel.cards.firstIndex { $0.id == card.id }!
                        stackedCardView(card, at: index)
                    }
                }
                .allowsHitTesting(viewModel.timeRemaining > 0)
                
                if viewModel.cards.isEmpty {
                    startAgainButton()
                }
            }
            
            editCardsButton { isShowingEditScreen = true }
            
            if differentiateWithoutColor || voiceOverEnabled {
                accessiblityButtons()
            }
        }
        .onChange(of: scenePhase, perform: { viewModel.update(scenePhase: $0) })
        .sheet(isPresented: $isShowingEditScreen, onDismiss: { viewModel.resetCards() }, content: EditCards.init)
        .onAppear{ viewModel.resetCards() }
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
