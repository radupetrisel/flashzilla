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
                .fill(differentiateWithoutColor
                      ? .white
                      : .white.opacity(1 - Double(abs(offset.width / 50))))
                .background(differentiateWithoutColor
                            ? nil
                            : RoundedRectangle(cornerRadius: 25, style: .continuous)
                                .fill(by: offset.width)
                )
                .shadow(radius: 10)
            
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
            .padding()
            .multilineTextAlignment(.center)
        }
        .frame(width: 450, height: 250)
        .rotationEffect(.degrees(Double(offset.width / 5)))
        .offset(x: offset.width * 5, y: 0)
        .opacity(2 - Double(abs(offset.width / 50)))
        .onTapGesture {
            isShowingAnswer.toggle()
        }
        .gesture(DragGesture()
            .onChanged { gesture in
                offset = gesture.translation
                feedbackGenerator.prepare()
            }
            .onEnded { _ in
                if abs(offset.width) > 100 {
                    if offset.width > 0 {
                        onDidSwipe?(true)
                        feedbackGenerator.notificationOccurred(.success)
                    } else {
                        feedbackGenerator.notificationOccurred(.error)
                        onDidSwipe?(false)
                    }
                } else {
                    
                    offset = .zero
                }
            })
        .animation(.spring(), value: offset)
        .accessibilityAddTraits(.isButton)
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
