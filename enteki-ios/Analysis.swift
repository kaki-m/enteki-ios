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
        VStack {
            ScoreGraph()
            HStack {
                HeatMap()
                Text("表")
            }
        }
        
    }
}
