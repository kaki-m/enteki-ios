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
            let hasHomeButton: Bool = {
                if let windowScene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
                   let window = windowScene.windows.first(where: { $0.isKeyWindow }) {
                    return window.safeAreaInsets.bottom == 0
                }
                return false
            }()
            let width = geometry.size.width  // **左半分にフィット**
            let tablePositionY =  UIDevice.current.userInterfaceIdiom == .pad ? geometry.size.height * 0.5 : 0
            let heatMapOffsetY = offsetYByiphoneScreenSize(hasHomeButton: hasHomeButton)
            VStack {
                ScoreGraph()
                    .offset(x:width*0.04)
                ZStack {
                    HeatMap()
                        .frame(maxWidth: .infinity)
                        .offset(x:width*0.03, y:heatMapOffsetY)
                    Spacer()
                    ScoreRatioTable()
                        .frame(width:width/2)
                        .offset(x:0,y:heatMapOffsetY)
                        .position(x: width*0.7,y:tablePositionY)
                }
            }
        }
    }
}

func offsetYByiphoneScreenSize(hasHomeButton: Bool) -> CGFloat{
    var returnFloatNum = CGFloat(-10)
    if hasHomeButton{
        returnFloatNum = CGFloat(-60)
    }
    print(returnFloatNum)
    return returnFloatNum
}

