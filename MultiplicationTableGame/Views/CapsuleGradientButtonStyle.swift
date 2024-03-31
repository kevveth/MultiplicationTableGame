//
//  CapsuleGradientButtonStyle.swift
//  MultiplicationTableGame
//
//  Created by Kenneth Oliver Rathbun on 3/20/24.
//

import SwiftUI

struct CapsuleGradientButtonStyle: ButtonStyle {
    @State private var isPressed = false
    var startRadius: CGFloat = 0
    var endRadius: CGFloat = 50
    
    func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .padding()
                .background(
                    Capsule()
                        .fill(RadialGradient(gradient: Gradient(colors: [.red, .yellow, .blue]), center: .center, startRadius: isPressed ? 2 : startRadius, endRadius: isPressed ? 150 : endRadius)) // Adjust radii based on isPressed
                )
                .foregroundStyle(.white)
                .font(.headline)
                .clipShape(Capsule())
                .scaleEffect(isPressed ? 1.1 : 1)
                .animation(.easeOut, value: isPressed)
                .simultaneousGesture(
                    TapGesture()
                        .onEnded { _ in
                            withAnimation { isPressed.toggle() }
                        }
                )
        }
}

extension View {
    func sunButton() -> some View {
        buttonStyle(CapsuleGradientButtonStyle())
    }
}

#Preview {
    Button("Start Game") {
        // Placeholder action
        print("Button tapped!")
    }
    .buttonStyle(CapsuleGradientButtonStyle())
}
