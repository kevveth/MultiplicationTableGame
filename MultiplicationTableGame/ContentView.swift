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
    
    // Game activity
    @State private var isActive = true
    
    var body: some View {
        NavigationStack {
            VStack(spacing: .none) {
                if !isActive {
                    Spacer()
                    Section("Times Table") {
                        RoundedSquareWithStepper(value: $multiplicationTable)
                    }
                    .font(.headline)
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    Section("Number of Questions") {
                        Picker("", selection: $selectedQuestionAmount) {
                            ForEach(amountOfQuestions, id: \.self) { amount in
                                Text("\(amount)")
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                    .font(.headline)
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    Section("Difficulty Level") {
                        Picker("", selection: $diffifulty) {
                            ForEach(difficultyLevel, id: \.self) { level in
                                Text("\(level)")
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                    .font(.headline)
                    .padding(.horizontal)
                    
                }
                Spacer()
                
                //
                if isActive {
                    Section("What is...?"){
                        QuestionDisplay(question: currentQuestion)
                    }
                    .font(.headline)
                    .padding(.top)
                    
                    Section{
                        HStack{
                            TextField("Type your answer here", text: $answer)
                                .keyboardType(.numberPad)
                                .textFieldStyle(.roundedBorder)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(LinearGradient(colors: [.red,.blue,.yellow], startPoint: .leading, endPoint: .trailing) , lineWidth: 2)
                                )
                            Button {
                                checkAnswer()
                            } label: {
                                Image(systemName: "equal.circle.fill")
                                    .font(.largeTitle)
                                    .shadow(radius: 6)
                            }
                        }
                        
                    }
                    .padding()
                    .onSubmit(checkAnswer)
                }
                
                HStack(){
                    if isActive {
                        Button("Main Menu", role: .destructive) {
                            resetGame()
                            isActive = false
                        }
                        .background {
                            Capsule(style: .continuous)
                                .frame(width: 120, height: 40)
                                .foregroundStyle(.paleRose)
                                .shadow(radius: 6)
                        }
                        .padding()
                    }
                    
                    Button {
                        startGame()
                        for index in 0..<questions.count {
                            print("\(questions[index]) || answer: \(questions[index].answer)")
                        }
                    } label: {
                        StartGameButton(isActive: $isActive)
                            .padding(.horizontal)
                    }
                }
                
                if isActive {
                    VStack {
                        Text("Turn: \(turn)/\(selectedQuestionAmount)")
                        Text("Score: \(score)")
                    }
                    .padding(.vertical)
                }
                
                Spacer()
                
            }
            .navigationTitle("⨷ Multiplier Master")
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
        .alert("Game Over!", isPresented: $gameIsOver) {
            Button("Reset") {
                resetGame()
                isActive = false
            }
        } message: {
            Text("Your final score is \(score)/\(selectedQuestionAmount)")
        }
    }
    
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
        if isActive { resetGame() }
        questions = generateQuestions(multplicationTable: multiplicationTable, amountOfQuestions: selectedQuestionAmount, difficultyLevel: diffifulty)
        
        currentQuestion = questions.first!
        isActive = true
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
            
            if turn < questions.count {
                turn += 1
                currentQuestion = questions[turn-1]
            } else {
                gameIsOver = true
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
}

#Preview {
    ContentView()
}
