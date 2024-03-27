//
//  ScaleUpDownModifier.swift
//  MultiplicationTableGame
//
//  Created by Kenneth Oliver Rathbun on 3/26/24.
//

import Foundation
import SwiftUI

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
