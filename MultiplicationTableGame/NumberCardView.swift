//
//  NumberCardView.swift
//  MultiplicationTableGame
//
//  Created by Kenneth Oliver Rathbun on 3/26/24.
//

import Foundation
import SwiftUI

struct NumberCard: View {
    let label: Int
    var color: Color = .blue
    var cornerSize: CGSize = .init(width: 20, height: 20)
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerSize: cornerSize)
                .stroke(color, style: StrokeStyle(lineWidth: 5, lineCap: .round))
                .frame(width: 100, height: 100)
            Text("\(label)")
                .font(.largeTitle)
            
        }
    }
}

#Preview {
    NumberCard(label: 7)
}
