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
    
    @StateObject private var viewModel = ViewModel()
    @State private var isShowingEditScreen = false

    
    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                Text("\(viewModel.timeRemaining)")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 5)
                    .background(.black.opacity(0.75))
                    .clipShape(Capsule())
                
                ZStack {
                    ForEach(viewModel.cards) { card in
                        let index = viewModel.cards.firstIndex { $0.id == card.id }!
                        
                        CardView(card: card) { isCorrect in
                            withAnimation {
                                viewModel.updateCard(cardAt: index, isCorrect: isCorrect)
                            }
                        }
                        .stacked(at: index, in: viewModel.cards.count)
                        .allowsTightening(index == viewModel.cards.count - 1)
                        .accessibilityHidden(index < viewModel.cards.count - 1)
                    }
                }
                .allowsHitTesting(viewModel.timeRemaining > 0)
                
                if viewModel.cards.isEmpty {
                    Button("Start again") { viewModel.resetCards() }
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
                                viewModel.updateLastCard(isCorrect: false)
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
                                viewModel.updateLastCard(isCorrect: true)
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
