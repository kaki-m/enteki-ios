import SwiftUI

struct ScoreGraph: View {
    @EnvironmentObject var arrowData: ArrowData

    var body: some View {
        VStack {
            GeometryReader { geometry in
                // 全てを1つの式としてラップ
                let computedView: some View = {
                    let scores: [Int] = arrowData.scores
                    var tmp_score: Int = 0
                    
                    let hasHomeButton: Bool = {
                        if let windowScene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
                           let window = windowScene.windows.first(where: { $0.isKeyWindow }) {
                            return window.safeAreaInsets.bottom == 0
                        }
                        return false
                    }()
                    
                    let width = geometry.size.width * 0.9
                    var height = UIDevice.current.userInterfaceIdiom == .pad
                        ? geometry.size.height * 0.7
                        : geometry.size.height * 0.5
                    height = (UIDevice.current.userInterfaceIdiom != .pad && hasHomeButton) ? height * 0.6 : height
                    
                    let maxX: CGFloat = 13
                    let maxY: CGFloat = 120
                    let stepX = width / maxX
                    let stepY = height / maxY
                    
                    return ZStack {
                        // Y軸グリッド線
                        Path { path in
                            for i in stride(from: 0, through: maxY, by: 20) {
                                let y = height - (CGFloat(i) * stepY)
                                path.move(to: CGPoint(x: 0, y: y))
                                path.addLine(to: CGPoint(x: width - 20, y: y))
                            }
                        }
                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        
                        // X軸グリッド線
                        Path { path in
                            for i in 0...12 {
                                let x = stepX * CGFloat(i)
                                path.move(to: CGPoint(x: x, y: 0))
                                path.addLine(to: CGPoint(x: x, y: height))
                            }
                        }
                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        
                        // グラフの線
                        Path { path in
                            if !scores.isEmpty {
                                path.move(to: CGPoint(x: 0, y: height))
                                for (index, score) in scores.enumerated() {
                                    let x = stepX * CGFloat(index + 1)
                                    let y = height - (CGFloat(score + tmp_score) * stepY)
                                    tmp_score += score
                                    path.addLine(to: CGPoint(x: x, y: y))
                                }
                            }
                        }
                        .stroke(Color.blue, lineWidth: 2)
                        
                        // X軸ラベル
                        ForEach(0...12, id: \.self) { num in
                            Text("\(num)")
                                .font(.caption)
                                .position(x: stepX * CGFloat(num), y: height + 10)
                        }
                        
                        // Y軸ラベル
                        ForEach(Array(stride(from: 0, through: 120, by: 20)), id: \.self) { num in
                            Text("\(num)")
                                .font(.caption)
                                .position(x: width, y: height - CGFloat(num) * stepY)
                        }
                    }
                }()
                computedView
            }
            .frame(height: 200)
            .padding()
        }
    }
}
