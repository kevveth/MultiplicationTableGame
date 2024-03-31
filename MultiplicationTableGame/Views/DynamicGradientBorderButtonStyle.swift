//
//  DynamicBorderButtonStyle.swift
//  MultiplicationTableGame
//
//  Created by Kenneth Oliver Rathbun on 3/20/24.
//

import SwiftUI

struct DynamicGradientBorderButtonStyle: ButtonStyle {
    var colors: [Color] = [.blue, .red] // Default colors
    var width: CGFloat = 200
    var height: CGFloat = 90
    var bgcolor: Color = .gray
    
    func makeBody(configuration: Configuration) -> some View {
        DynamicGradientBorderCapsule(colors: colors, width: width, height: height, background: bgcolor)
            .opacity(configuration.isPressed ? 0.8 : 1.0) // Add a pressed state effect
    }
}

extension View {
    func dynamicGradientBorderCapsule(width: CGFloat = 200, height: CGFloat = 90, colors: [Color], bgcolor: Color) -> some View {
        buttonStyle(DynamicGradientBorderButtonStyle(colors: colors, width: width, height: height, bgcolor: bgcolor))
    }
}

#Preview {
    Button("Start Game") {
        print("Button tapped!")
    }
    .buttonStyle(DynamicGradientBorderButtonStyle())
}
