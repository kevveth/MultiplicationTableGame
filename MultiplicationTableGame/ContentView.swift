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
    @State private var selectedQuestionAmount: Int = 5
    
    
    // Randomly generate as many questions as they asked for, within the difficulty range they asked for
    @State private var questions: [Question] = []
    @State private var currentQuestion = Question()
    
    // Record player's answer
    @State private var answer: String = ""
    
    // Game data
    @State private var score: Int = 0
    @State private var turn: Int = 0
    
    // Alerts
    @State private var gameIsOver = false
    @State private var isCorrect = false
    @State private var isIncorrect = false
    
    func generateQuestions(multplicationTable: Int, amountOfQuestions: Int) -> [Question] {
        var questions: [Question] = Array(repeating: Question(), count: amountOfQuestions)
        
        
        for index in 0..<questions.count {
            questions[index] = Question(firstNumber: multplicationTable, secondNumber: Int.random(in: 0...12))
        }
        
        return questions
    }
    
    func startGame() {
        resetGame()
        questions = generateQuestions(multplicationTable: multiplicationTable, amountOfQuestions: selectedQuestionAmount)
        currentQuestion = questions.first!
    }
    
    func checkAnswer() {
        let answer: Int = Int(answer)!
        
        if answer == currentQuestion.answer {
            score += 1
            isCorrect = true
        } else {
            isIncorrect = true
        }
        
        turn += 1
        if turn == selectedQuestionAmount { gameIsOver = true }
        
        currentQuestion = questions[turn-1]
    }
    
    func resetGame() {
        questions = []
        currentQuestion = Question()
        answer = ""
        score = 0
        turn = 0
        gameIsOver = false
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
                
                QuestionDisplay(question: currentQuestion)
                    
                Section("Type your answer here"){
                    TextField("Type your answer here", text: $answer)
                        .keyboardType(.numberPad)
                        .textFieldStyle(.roundedBorder)
                    
                }
                .padding([.top, .horizontal])
                
                Button {
                    startGame()
                    //                    for index in 0..<questions.count {
                    //                        print("\(questions[index]) || answer: \(questions[index].answer)")
                    //                    }
                } label: {
                    Text("Start Game")
                }
                .padding()
                
                Text("Turn: \(turn)/\(selectedQuestionAmount)")
                Text("Score: \(score)")
                
                Spacer()
                Spacer()
                
            }
            .navigationTitle("⨷ Multiplier Master")
        }
        .onSubmit(checkAnswer)
        .alert("That's correct! 🥳", isPresented: $isCorrect) {
            Button("Continue") { answer = "" }
        } message: {
            Text("Your score is \(score)")
        }
        .alert("That's incorrect! 🥺", isPresented: $isIncorrect) {
            Button("Continue") { answer = "" }
        } message: {
            Text("Your score is \(score)")
        }
        .alert("Game Over!", isPresented: $gameIsOver) {
            Button("Reset", action: resetGame)
        } message: {
            Text("Your final score is \(score)/\(selectedQuestionAmount)")
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

struct QuestionDisplay: View {
    let question: Question
    
    var body: some View {
        HStack {
            Spacer()
            
            NumberBox(label: question.firstNumber)
            
            Spacer()
            
            Image(systemName: "xmark")
                .font(.largeTitle)
            
            Spacer()
            
            NumberBox(label: question.secondNumber)
            
            Spacer()
        }
    }
}

struct NumberBox: View {
    let label: Int
    var color: Color = .blue
    var cornerSize: CGSize = .init(width: 20, height: 20)
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerSize: cornerSize)
                .stroke(color, style: StrokeStyle(lineWidth: 5, lineCap: .round))
                .frame(width: 100, height: 100)
            Text("\(label)")
                .font(.largeTitle)
            
        }
    }
}

// -- MODIFIERS --

// Scales the picker image up and down
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
