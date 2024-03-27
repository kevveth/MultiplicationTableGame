//
//  StartGameButton.swift
//  MultiplicationTableGame
//
//  Created by Kenneth Oliver Rathbun on 3/21/24.
//

import SwiftUI

struct StartGameButton: View {
    @Binding var isActive: Bool
    
    var body: some View {
        ZStack{
            Capsule()
                .frame(height: !isActive ? 50 : 40)
                .frame(maxWidth: !isActive ? .infinity : 120)
//                .padding(.horizontal)
                .shadow(radius: 6)
            
            Text(!isActive ? "Start Game" : "Regenerate")
                .bold()
                .font(!isActive ? .largeTitle : .headline)
                .foregroundStyle(.white)
                .padding()
        }
    }
}

#Preview {
    StartGameButton(isActive: .constant(false))
        .previewDisplayName("Start Game (Inactive)")
//    StartGameButton(isActive: .constant(true))
//        .previewDisplayName("Regenerate (Active)")
}
