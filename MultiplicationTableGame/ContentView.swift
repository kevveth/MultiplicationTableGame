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
    @State private var answer: String = ""
    @State private var questions: [Question] = []
    
    func generateQuestions(multplicationTable: Int, amountOfQuestions: Int) -> [Question] {
        var questions: [Question] = Array(repeating: Question(), count: amountOfQuestions)
        
        
        for index in 0..<questions.count {
            questions[index] = Question(firstNumber: multplicationTable, secondNumber: Int.random(in: 0...12))
        }
        
        return questions
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                Section("Times Table") {
                    Stepper(value: $multiplicationTable, in: 2...12, step: 1) {
                        HStack {
                            Text("")
                            Image(systemName: "\(multiplicationTable).square")
                                .font(.title)
                        }
                        .scaleUpDown(multiplicationTable: multiplicationTable)
                    }
                }
                .padding([.bottom, .horizontal])
                
                Section("Number of Questions") {
                    Picker("", selection: $selectedQuestionAmount) {
                        ForEach(amountOfQuestions, id: \.self) { amount in
                            Text("\(amount)")
                        }
                    }
                    .pickerStyle(.segmented)
                }
                .padding([.bottom, .horizontal])
                
                Text("What is...?")
                
                HStack {
                    Spacer()
                    NumberBox(label: multiplicationTable)
                    Spacer()
                    Image(systemName: "xmark")
                        .font(.largeTitle)
                    Spacer()
                    NumberBox(label: multiplicationTable)
                    Spacer()
                }
                
                Section("Type your answer here"){
                    TextField("Type your answer here", text: $answer)
                        .keyboardType(.numberPad)
                        .textFieldStyle(.roundedBorder)

                }
                .padding([.top, .horizontal])
                
                Button {
                    questions = generateQuestions(multplicationTable: multiplicationTable, amountOfQuestions: selectedQuestionAmount)
                    for index in 0..<questions.count {
                        print("\(questions[index]) || answer: \(questions[index].answer)")
                    }
                } label: {
                    Text("Generate")
                }
                
                Spacer()
                Spacer()
                
            }
            .navigationTitle("⨷ Multiplier Master")
        }
    }
}

struct Question {
    var firstNumber: Int = 0
    var secondNumber: Int = 0
    var answer: Int {
        firstNumber * secondNumber
    }
}

// -- VIEWS --

struct NumberBox: View {
    let label: Int
    let cornerSize: CGSize = .init(width: 20, height: 20)
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerSize: cornerSize)
                .stroke(Color.red, style: StrokeStyle(lineWidth: 5, lineCap: .round))
                .frame(width: 100, height: 100)
            Text("\(label)")
                .font(.largeTitle)
        }
    }
}

// -- MODIFIERS --

// Scales the times table number up and down
@MainActor
struct ScaleUpDown: ViewModifier {
    @State private var animating = false
    var multiplicaitonTable: Int
    var delay: Double
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(animating ? 1.3: 1.0)
            .onChange(of: multiplicaitonTable) {
                
                withAnimation(.easeOut) {
                    animating = true
                }
                Task {
                    try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
                    withAnimation(.easeIn) {
                        animating = false
                    }
                }
                
            }
    }
}

extension View {
    func scaleUpDown(multiplicationTable: Int, delay: Double = 0.5) -> some View {
        modifier(ScaleUpDown(multiplicaitonTable: multiplicationTable, delay: delay))
    }
}

#Preview {
    ContentView()
}
