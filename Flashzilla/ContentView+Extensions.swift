//
//  ContentView+Extensions.swift
//  Flashzilla
//
//  Created by Radu Petrisel on 28.07.2023.
//

import SwiftUI

extension ContentView {
    func timeCapsule() -> some View {
        Text("\(viewModel.timeRemaining)")
            .font(.largeTitle)
            .foregroundColor(.white)
            .padding(.horizontal, 20)
            .padding(.vertical, 5)
            .background(.black.opacity(0.75))
            .clipShape(Capsule())
    }
    
    func stackedCardView(_ card: Card, at index: Int) -> some View {
        CardView(card: card) { isCorrect in
            withAnimation {
                viewModel.updateCard(cardAt: index, isCorrect: isCorrect)
            }
        }
        .stacked(at: index, in: viewModel.cards.count)
        .allowsTightening(index == viewModel.cards.count - 1)
        .accessibilityHidden(index < viewModel.cards.count - 1)
    }
    
    func startAgainButton() -> some View {
        Button("Start again") { viewModel.resetCards() }
            .padding()
            .background(.white)
            .foregroundColor(.black)
            .clipShape(Capsule())
    }
    
    func editCardsButton(_ action: @escaping () -> ()) -> some View {
        VStack {
            HStack {
                Spacer()
                
                Button(action: action) {
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
    }
    
    func accessiblityButtons() -> some View {
        VStack {
            Spacer()
            HStack {
                swipeCardButton("Wrong", systemImageName: "xmark.circle", isCorrect: false, accessibilityHint: "Mark your answer as being wrong")
                
                Spacer()
                
                swipeCardButton("Correct", systemImageName: "checkmark.circle", isCorrect: true, accessibilityHint: "Mark your answer as being correct")
            }
            .foregroundColor(.white)
            .font(.title)
            .padding()
        }
    }
    
    private func swipeCardButton(_ name: String, systemImageName: String, isCorrect: Bool, accessibilityHint: String) -> some View {
        Button {
            withAnimation {
                viewModel.updateLastCard(isCorrect: isCorrect)
            }
        } label: {
            Image(systemName: systemImageName)
                .padding()
                .background(.black.opacity(0.7))
                .clipShape(Circle())
        }
        .accessibilityLabel(name)
        .accessibilityHint(accessibilityHint)
    }
}
