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
            let tablePositionY =  UIDevice.current.userInterfaceIdiom == .pad ? geometry.size.height * 0.5 : 0
            VStack {
                ScoreGraph()
                    .offset(x:width*0.04)
                ZStack {
                    HeatMap()
                        .frame(maxWidth: .infinity)
                        .offset(x:width*0.03, y:-10)
                    Spacer()
                    ScoreRatioTable()
                        .frame(width:width/2)
                        .position(x: width*0.7,y:tablePositionY)
                }
            }
        }
    }
}
