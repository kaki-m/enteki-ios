//
//  Analysis.swift
//  enteki-ios
//
//  Created by 柿崎愛斗 on 2025/02/02.
//

import SwiftUI

struct Analysis: View {
    @EnvironmentObject var arrowData: ArrowData
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width  // **左半分にフィット**
            VStack {
                ScoreGraph()
                ZStack {
                    HeatMap()
                        .frame(maxWidth: .infinity)
                    Spacer()
                    ScoreRatioTable()
                        .frame(width:width/2)
                        .position(x: width*0.7)
                }
            }
        }
    }
}
