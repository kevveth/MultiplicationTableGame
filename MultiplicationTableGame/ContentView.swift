//
//  ContentView.swift
//  MultiplicationTableGame
//
//  Created by Kenneth Oliver Rathbun on 3/12/24.
//

import SwiftUI

struct ContentView: View {
    // Player needs to select a multiplication table to practice
    @State private var multiplicationTable: Int = 2
    
    // Player should be asked how many questions they want to be asked: 5, 10, or 20
    let amountOfQuestions = [5, 10, 15, 20]
    @State private var selectedQuestionAmount = 5
    
    // Randomly generate as many questions as they asked for, within the difficulty range they asked for
    
    // Animation State
    @State private var symbolAnimationAmount = 1.0
    @State private var animating = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Times Table") {
                    Stepper(value: $multiplicationTable, in: 2...12, step: 1) {
                        HStack {
                            Text("")
                            Image(systemName: "\(multiplicationTable).square")
                                .font(.title)
                                .scaleEffect(animating ? 1.3 : 1.0)
                        }
                    }
                    .onChange(of: multiplicationTable) {
                        withAnimation(.easeOut) {
                            animating = true
                        }
                        
                        Task { @MainActor in
                            try? await Task.sleep(nanoseconds: 667_000_000)
                            withAnimation(.easeIn) {
                                animating = false
                            }
                        }
                        
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.33) {
//                            withAnimation(.easeOut) {
//                                animating = false
//                            }
//                        }
                    }
                }
                
                Section("Number of Questions") {
                    Picker("", selection: $selectedQuestionAmount) {
                        ForEach(amountOfQuestions, id: \.self) { amount in
                            Text("\(amount)")
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
            }
            .navigationTitle("⨷ Multiplier Master")
        }
    }
}

#Preview {
    ContentView()
}
