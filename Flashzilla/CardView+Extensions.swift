//
//  CardView+Extensions.swift
//  Flashzilla
//
//  Created by Radu Petrisel on 28.07.2023.
//

import SwiftUI

extension CardView {
    func cardContent(_ card: Card, isShowingAnswer: Bool, voiceOverEnabled: Bool) -> some View {
        VStack {
            if voiceOverEnabled {
                Text(isShowingAnswer ? card.answer : card.prompt)
                    .font(.largeTitle)
                    .foregroundColor(.black)
            } else {
                Text(card.prompt)
                    .font(.largeTitle)
                    .foregroundColor(.black)
                
                if isShowingAnswer {
                    Text(card.answer)
                        .font(.title)
                        .foregroundColor(.gray)
                }
            }
        }
    }
    
    func cardOpacity(using offset: CGSize) -> Double {
        2 - Double(abs(offset.width / 50))
    }
    
    func cardFill(using offset: CGSize, differentiateWithoutColor: Bool) -> Color {
        differentiateWithoutColor
              ? .white
              : .white.opacity(1 - Double(abs(offset.width / 50)))
    }
    
    func cardBackground(using offset: CGSize, differentiateWithoutColor: Bool) -> (some View)? {
        differentiateWithoutColor
                    ? nil
                    : RoundedRectangle(cornerRadius: 25, style: .continuous)
            .fill(by: offset.width)
    }
}
