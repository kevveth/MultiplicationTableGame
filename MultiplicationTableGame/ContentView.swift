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
    
    // Player should be asked how many questions they want to be asked: 5, 10, 15 or 20
    let amountOfQuestions = [5, 10, 15, 20]
    @State private var selectedQuestionAmount: Int = 5
    
    // Player should choose a difficulty level between 1 and 3
    let difficultyLevel = [1, 2, 3]
    @State private var diffifulty: Int = 1
    
    // Randomly generate as many questions as they asked for, within the difficulty range they asked for
    @State private var questions: [Question] = []
    @State private var currentQuestion = Question()
    
    // Record player's answer
    @State private var answer: String = ""
    
    // Game data
    @State private var score: Int = 0
    @State private var turn: Int = 1
    
    // Alerts
    @State private var gameIsOver = false
    @State private var isCorrect = false
    @State private var isIncorrect = false
    
    // Error handling
    @State private var errorTitle: String = ""
    @State private var errorMessage: String = ""
    @State private var showingError = false
    
    @State private var activeGame = false
    
    func generateQuestions(multplicationTable: Int, amountOfQuestions: Int, difficultyLevel: Int) -> [Question] {
        var questions: [Question] = Array(repeating: Question(), count: amountOfQuestions)
        
        for index in 0..<questions.count {
            
            
            switch difficultyLevel {
            case 1:
                questions[index] = Question(firstNumber: multplicationTable, secondNumber: Int.random(in: 0...3))
            case 2:
                questions[index] = Question(firstNumber: multplicationTable, secondNumber: Int.random(in: 4...7))
            case 3:
                questions[index] = Question(firstNumber: multplicationTable, secondNumber: Int.random(in: 8...12))
            default:
                questions[index] = Question(firstNumber: multplicationTable, secondNumber: Int.random(in: 0...12))
            }
        }
        
        return questions
    }
    
    func startGame() {
        if activeGame { resetGame() }
        questions = generateQuestions(multplicationTable: multiplicationTable, amountOfQuestions: selectedQuestionAmount, difficultyLevel: diffifulty)
        
        currentQuestion = questions.first!
        activeGame = true
    }
    
    func checkAnswer() {
        let answer: Int? = Int(answer)
        
        if let answer = answer {
            if answer == currentQuestion.answer {
                score += 1
                isCorrect = true
            } else {
                isIncorrect = true
            }
            
            if turn == questions.count { gameIsOver = true }
            
            if turn < questions.count {
                turn += 1
                currentQuestion = questions[turn-1]
            }
        } else {
            inputError(title: "Your input's lookin' a little empty there", message: "Try guessing if you don't know! 🤠")
        }
        
    }
    
    func resetGame() {
        questions = []
        currentQuestion = Question()
        answer = ""
        score = 0
        turn = 1
        gameIsOver = false
    }
    
    func inputError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
    
    @State private var animating = false
    
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
                        .scaleEffect(animating ? 1.3 : 1)
                        .onChange(of: multiplicationTable) {
                            withAnimation(.interpolatingSpring(stiffness: 170, damping: 5)) {
                                animating = true
                            }
                            animating = false
                        }
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
                
                Spacer()
                
                Section("Difficulty Level") {
                    Picker("", selection: $diffifulty) {
                        ForEach(difficultyLevel, id: \.self) { level in
                            Text("\(level)")
                        }
                    }
                    .pickerStyle(.segmented)
                }
                .padding([.bottom, .horizontal])
                
                Spacer()
                
                Section("What is...?"){
                    QuestionDisplay(question: currentQuestion)
                }
                .padding(.top)
                
                if activeGame {
                    Section("What is...?"){
                        TextField("Type your answer here", text: $answer)
                            .keyboardType(.numberPad)
                            .textFieldStyle(.roundedBorder)
                        
                    }
                    .padding([.top, .horizontal])
                    .onSubmit(checkAnswer)
                }
                
                //                if !activeGame {
                Button {
                    startGame()
                    for index in 0..<questions.count {
                        print("\(questions[index]) || answer: \(questions[index].answer)")
                    }
                } label: {
                    Text(!activeGame ? "Start Game" : "Reset Game")
                }
                .sunButton()
                //                }
                
                Text("Turn: \(turn)/\(selectedQuestionAmount)")
                Text("Score: \(score)")
                
                Spacer()
                Spacer()
                
            }
            .navigationTitle("⨷ Multiplier Master")
        }
        .alert("Game Over!", isPresented: $gameIsOver) {
            Button("Reset") {
                activeGame = false
                resetGame()
            }
        } message: {
            Text("Your final score is \(score)/\(selectedQuestionAmount)")
        }
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
        .alert(errorTitle, isPresented: $showingError) {
            Button("Continue") { answer = "" }
        } message: {
            Text(errorMessage)
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
