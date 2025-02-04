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
            let width = geometry.size.width * 0.43  // **左半分にフィット**
            let height = width  // **正方形に近い形にする**
            let centerX = width * 0.5  // **中央**
            let centerY = height * 0.001  // **さらに上に移動**
            let radius = width * 0.4  // **円のサイズを調整**
            
            let rectangleWidth = radius * 1.3
            let rectangleHeight = radius * 1.3  // **四角形のサイズも調整**
            let squareRatio = calculateQuadrantRatios(positions: arrowData.positions, centerOfTarget: arrowData.targetCenterPosition)
            
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
                        .fill(heatMapColor(value: squareRatio[2]))
                        .frame(width: rectangleWidth, height: rectangleHeight)
                        .position(x: centerX - rectangleWidth / 2, y: centerY - rectangleHeight / 2)
                        .opacity(0.2)
                    Text("\(String(format: "%.2f", squareRatio[2]))%")
                        .position(x: centerX - rectangleWidth / 2, y: centerY - rectangleHeight / 2)
                    
                    // **右上の四角形**
                    Rectangle()
                        .fill(heatMapColor(value: squareRatio[0]))
                        .frame(width: rectangleWidth, height: rectangleHeight)
                        .position(x: centerX + rectangleWidth / 2, y: centerY - rectangleHeight / 2)
                        .opacity(0.2)
                    Text("\(String(format: "%.2f", squareRatio[0]))%")
                        .position(x: centerX + rectangleWidth / 2, y: centerY - rectangleHeight / 2)
                    
                    // **左下の四角形**
                    Rectangle()
                        .fill(heatMapColor(value: squareRatio[3]))
                        .frame(width: rectangleWidth, height: rectangleHeight)
                        .position(x: centerX - rectangleWidth / 2, y: centerY + rectangleHeight / 2)
                        .opacity(0.2)
                    Text("\(String(format: "%.2f", squareRatio[3]))%")
                        .position(x:centerX - rectangleWidth / 2, y: centerY + rectangleHeight / 2)
                    
                    // **右下の四角形**
                    Rectangle()
                        .fill(heatMapColor(value: squareRatio[1]))
                        .frame(width: rectangleWidth, height: rectangleHeight)
                        .position(x: centerX + rectangleWidth / 2, y: centerY + rectangleHeight / 2)
                        .opacity(0.2)
                    Text("\(String(format: "%.2f", squareRatio[1]))%")
                        .position(x:centerX + rectangleWidth / 2, y:centerY + rectangleHeight / 2)
                }
            }
        }
    }
    }
    }


/// 数値に応じてヒートマップ風の色を返す関数
func heatMapColor(value: Double) -> Color {
    let minValue: Double = 0
    let maxValue: Double = 100
    // 値を 0.0 ~ 1.0 の範囲に正規化（minValue が青、maxValue が赤）
    let normalized = (value - minValue) / (maxValue - minValue)

    // 青 → 緑 → 黄色 → 赤 に変化する
    let color = Color(hue: (1.0 - normalized) * 0.4, saturation: 1.0, brightness: 1.0)

    return color
}

import CoreGraphics
/// 位置情報の配列を元に、各象限に何割あるかを計算する関数
/// - Parameter positions: `CGPoint` の配列（座標データ）
/// - Returns: [右上, 右下, 左上, 左下] の割合 (Float)
func calculateQuadrantRatios(positions: [CGPoint], centerOfTarget: CGPoint) -> [Double] {
    guard !positions.isEmpty else {
        return [0.0, 0.0, 0.0, 0.0]  // データが空なら全て 0 割
    }

    // 中心座標を計算（X の中央値、Y の中央値）
    let centerX = centerOfTarget.x
    let centerY = centerOfTarget.y

    // 各象限のカウント
    var upperRight = 0
    var lowerRight = 0
    var upperLeft = 0
    var lowerLeft = 0

    for position in positions {
        if position.x >= centerX {
            if position.y <= centerY {
                upperRight += 1  // 右上
            } else {
                lowerRight += 1  // 右下
            }
        } else {
            if position.y <= centerY {
                upperLeft += 1  // 左上
            } else {
                lowerLeft += 1  // 左下
            }
        }
    }

    // 合計データ数
    let total = Double(positions.count)

    // 各象限の割合を計算
    let ratios: [Double] = [
        Double(upperRight) / total * 100,
        Double(lowerRight) / total * 100,
        Double(upperLeft) / total * 100,
        Double(lowerLeft) / total * 100
    ]

    return ratios
}

