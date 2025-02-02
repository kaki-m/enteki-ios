//
//  HeatMap.swift
//  enteki-ios
//
//  Created by 柿崎愛斗 on 2025/02/02.
//

//的のどこに集まってるかと中心からの距離の平均表示
import SwiftUI

struct HeatMap: View {
    @EnvironmentObject var arrowData: ArrowData
    
    var body: some View {
    HStack {
        GeometryReader { geometry in
            let width = geometry.size.width * 0.5  // **左半分にフィット**
            let height = width  // **正方形に近い形にする**
            let centerX = width * 0.5  // **中央**
            let centerY = height * 0.001  // **さらに上に移動**
            let radius = width * 0.4  // **円のサイズを調整**
            
            let rectangleWidth = radius * 1.3
            let rectangleHeight = radius * 1.3  // **四角形のサイズも調整**
            
            ZStack {
                // **円**
                Circle()
                    .frame(width: radius * 2, height: radius * 2)
                    .foregroundColor(Color.gray)
                    .opacity(0.5)
                    .position(x: centerX, y: centerY)
                
                // **横点線**
                Path { path in
                    path.move(to: CGPoint(x: centerX - radius, y: centerY))
                    path.addLine(to: CGPoint(x: centerX + radius, y: centerY))
                }
                .stroke(Color.gray, style: StrokeStyle(lineWidth: 2, dash: [5, 5]))
                
                // **縦点線**
                Path { path in
                    path.move(to: CGPoint(x: centerX, y: centerY - radius))
                    path.addLine(to: CGPoint(x: centerX, y: centerY + radius))
                }
                .stroke(Color.gray, style: StrokeStyle(lineWidth: 2, dash: [5, 5]))
                
                // **四角形の配置**
                ZStack {
                    // **左上の四角形**
                    Rectangle()
                        .fill(heatMapColor(value: CGFloat(100)))
                        .frame(width: rectangleWidth, height: rectangleHeight)
                        .position(x: centerX - rectangleWidth / 2, y: centerY - rectangleHeight / 2)
                        .opacity(0.2)
                    
                    // **右上の四角形**
                    Rectangle()
                        .fill(heatMapColor(value: CGFloat(50)))
                        .frame(width: rectangleWidth, height: rectangleHeight)
                        .position(x: centerX + rectangleWidth / 2, y: centerY - rectangleHeight / 2)
                        .opacity(0.2)
                    
                    // **左下の四角形**
                    Rectangle()
                        .fill(heatMapColor(value: CGFloat(30)))
                        .frame(width: rectangleWidth, height: rectangleHeight)
                        .position(x: centerX - rectangleWidth / 2, y: centerY + rectangleHeight / 2)
                        .opacity(0.2)
                    
                    // **右下の四角形**
                    Rectangle()
                        .fill(heatMapColor(value: CGFloat(0)))
                        .frame(width: rectangleWidth, height: rectangleHeight)
                        .position(x: centerX + rectangleWidth / 2, y: centerY + rectangleHeight / 2)
                        .opacity(0.2)
                }
            }
        }
    }
    }
    }


    /// 数値に応じてヒートマップ風の色を返す関数
    func heatMapColor(value: CGFloat) -> Color {
    let minValue: CGFloat = 0
    let maxValue: CGFloat = 100
    // 値を 0.0 ~ 1.0 の範囲に正規化（minValue が青、maxValue が赤）
    let normalized = (value - minValue) / (maxValue - minValue)

    // 青 → 緑 → 黄色 → 赤 に変化する
    let color = Color(hue: (1.0 - normalized) * 0.4, saturation: 1.0, brightness: 1.0)

    return color
}
