//
//  CardView.swift
//  Flashzilla
//
//  Created by Radu Petrisel on 27.07.2023.
//

import SwiftUI

struct CardView: View {
    let card: Card
    var onDidSwipe: ((Bool) -> Void)? = nil
    
    @Environment(\.accessibilityDifferentiateWithoutColor) private var differentiateWithoutColor
    @Environment(\.accessibilityVoiceOverEnabled) private var voiceOverEnabled
    
    @State private var feedbackGenerator = UINotificationFeedbackGenerator()
    
    @State private var isShowingAnswer = false
    @State private var offset = CGSize.zero
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(cardFill(using: offset, differentiateWithoutColor: differentiateWithoutColor))
                .background(cardBackground(using: offset, differentiateWithoutColor: differentiateWithoutColor))
                .shadow(radius: 10)
            
            cardContent(card, isShowingAnswer: isShowingAnswer, voiceOverEnabled: voiceOverEnabled)
                .padding()
                .multilineTextAlignment(.center)
        }
        .frame(width: 450, height: 250)
        .rotationEffect(.degrees(Double(offset.width / 5)))
        .offset(x: offset.width * 5, y: 0)
        .opacity(cardOpacity(using: offset))
        .onTapGesture {
            isShowingAnswer.toggle()
        }
        .gesture(dragGesture)
        .animation(.spring(), value: offset)
        .accessibilityAddTraits(.isButton)
    }
    
    var dragGesture: some Gesture {
        DragGesture()
            .onChanged(onDragChanged(_:))
            .onEnded { _ in onDragEnded()}
    }
    
    private func onDragChanged(_ gesture: DragGesture.Value) {
        offset = gesture.translation
        feedbackGenerator.prepare()
    }
    
    private func onDragEnded() {
        if abs(offset.width) > 100 {
            if offset.width > 0 {
                feedbackGenerator.notificationOccurred(.success)
                onDidSwipe?(true)
            } else {
                feedbackGenerator.notificationOccurred(.error)
                onDidSwipe?(false)
            }
        } else {
            offset = .zero
        }
    }
}

extension Shape {
    func fill(by offset: Double) -> some View{
        switch offset {
        case 0:
            return self.fill(.white)
        case ..<0:
            return self.fill(.red)
        case 0...:
            return self.fill(.green)
        default:
            fatalError("Math was not on your side today.")
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: .preview)
    }
}
