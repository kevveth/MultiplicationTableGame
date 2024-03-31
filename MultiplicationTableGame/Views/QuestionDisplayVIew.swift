//
//  QuestionDisplayVIew.swift
//  MultiplicationTableGame
//
//  Created by Kenneth Oliver Rathbun on 3/26/24.
//

import SwiftUI

struct QuestionDisplay: View {
    let question: Question
    
    var body: some View {
        HStack {
            Spacer()
            
            NumberCard(label: question.firstNumber)
            
            Spacer()
            
            Image(systemName: "xmark")
                .font(.largeTitle)
            
            Spacer()
            
            NumberCard(label: question.secondNumber)
            
            Spacer()
        }
    }
}

#Preview {
    QuestionDisplay(question: Question())
}
