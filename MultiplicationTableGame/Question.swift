//
//  Question.swift
//  MultiplicationTableGame
//
//  Created by Kenneth Oliver Rathbun on 3/26/24.
//

import Foundation

struct Question: Equatable {
    var firstNumber: Int = 0
    var secondNumber: Int = 0
    var answer: Int {
        firstNumber * secondNumber
    }
}
