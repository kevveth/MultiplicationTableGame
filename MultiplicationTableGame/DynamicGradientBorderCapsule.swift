//
//  DynamicGradientBorderCapsule.swift
//  MultiplicationTableGame
//
//  Created by Kenneth Oliver Rathbun on 3/20/24.
//

import SwiftUI

struct DynamicGradientBorderCapsule: View {
    @State var rotation: CGFloat = 0.0
    @State var colors: [Color]
    @State var width: CGFloat = 300
    @State var height: CGFloat = 90
    @State var background: Color = .clear
    
    var body: some View {
        ZStack {
            Capsule(style: .continuous)
                .frame(width: width, height: height)
                .foregroundStyle(background)
                .shadow(radius: 10)
            Rectangle()
                .frame(width: width, height:  height/1.5)
                .foregroundStyle(LinearGradient(colors: colors, startPoint: .leading, endPoint: .trailing))
                .rotationEffect(.degrees(rotation))
                .mask {
                    Capsule(style: .continuous)
                        .stroke(lineWidth: 20)
                        .frame(width: width-(width/100), height: height-(height/100))
                }
            Text("Press Me")
        }
        .mask {
            Capsule(style: .continuous)
                .frame(width: width, height: height)
        }
        .onAppear {
            withAnimation(.linear(duration: 4).repeatForever(autoreverses: false)) {
                rotation = 360
            } completion: {
                rotation = 0
            }
        }
        
        
    }
}

#Preview {
    DynamicGradientBorderCapsule(colors: [.purple, .orange, .yellow])
}
