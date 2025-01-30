//
//  ScoreBoard.swift
//  enteki-ios
//
//  Created by 柿崎愛斗 on 2024/04/11.
//

import SwiftUI

struct ScoreBoard: View {
    @Binding var positions: [CGPoint]
    var body: some View {
        Text("得点表")
    }
}

#Preview {
    var testData: Binding<[CGPoint]> = .constant([
        CGPoint(x: 100, y: 200),
        CGPoint(x: 150, y: 250),
        CGPoint(x: 200, y: 300),
        CGPoint(x: 250, y: 350),
        CGPoint(x: 300, y: 400)
    ])
    ScoreBoard(positions: testData)
}
