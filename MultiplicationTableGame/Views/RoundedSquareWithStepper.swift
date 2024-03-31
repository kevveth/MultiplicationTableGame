//
//  RoundedSquareWithStepper.swift
//  MultiplicationTableGame
//
//  Created by Kenneth Oliver Rathbun on 3/29/24.
//

import SwiftUI

struct RoundedSquareWithStepper: View {
    @Binding var value: Int
    var range: ClosedRange<Int> = 2...12
    
    @State private var isAnimating = false
    
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 100, height: 100)
                
                Text("\(value)")
                    .font(.title)
                    .fontWeight(.semibold)
                    .scaleUpDown(multiplicationTable: value)
                    .scaleEffect(isAnimating ? 1.3 : 1)
                    .onChange(of: value) {
                        withAnimation(.interpolatingSpring(stiffness: 170, damping: 5)) {
                            isAnimating = true
                        }
                        isAnimating = false
                    }
            }
            .padding(.bottom)
            
            CustomStepper(value: $value, range: range)  // Replace the standard stepper
        }
    }
}

struct CustomStepper: View {
    @Binding var value: Int
    let range: ClosedRange<Int>
        
    var body: some View {
        HStack {
            Button {
                let newValue = value - 1
                value = max(range.lowerBound, newValue)
            } label: {
                Image(systemName: "minus.circle.fill")
                    .font(.title)
                    .foregroundColor(.red)
                    .shadow(radius: 10)
            }
            
            Spacer()
            
            Button {
                let newValue = value + 1
                value = min(range.upperBound, newValue)
            } label: {
                Image(systemName: "plus.circle.fill")
                    .font(.title)
                    .foregroundColor(.green)
                    .shadow(radius: 10)
            }
        }
        .frame(width: 100)
    }
}



#Preview {
    RoundedSquareWithStepper(value: .constant(7))
}
