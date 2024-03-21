//
//  DynamicBorderButtonStyle.swift
//  MultiplicationTableGame
//
//  Created by Kenneth Oliver Rathbun on 3/20/24.
//

import SwiftUI

struct DynamicGradientBorderButtonStyle: ButtonStyle {
    var colors: [Color] = [.blue, .red] // Default colors
        var width: CGFloat = 300
        var height: CGFloat = 90

        func makeBody(configuration: Configuration) -> some View {
            DynamicGradientBorderCapsule(colors: colors, width: width, height: height)
                .opacity(configuration.isPressed ? 0.8 : 1.0) // Add a pressed state effect
        }
}

#Preview {
    Button("Start Game") {
        print("Button tapped!")
    }
    .buttonStyle(DynamicGradientBorderButtonStyle())
}
