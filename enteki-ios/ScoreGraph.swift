import SwiftUI

struct ScoreGraph: View {
    @EnvironmentObject var arrowData: ArrowData
    
    var body: some View {
        VStack{
            // グラフ描画
            GeometryReader { geometry in
                let scores: [Int] = arrowData.scores
                var tmp_score: Int = 0
                let width = geometry.size.width * 0.9
                let height = UIDevice.current.userInterfaceIdiom == .pad ? geometry.size.height * 0.7 : geometry.size.height * 0.5
                
                let maxX: CGFloat = 13  // X 軸を 1〜12 に固定
                let maxY: CGFloat = 120 // Y 軸を 0〜120 に固定
                
                let stepX = width / maxX  // X 軸の間隔を固定
                let stepY = height / maxY // Y 軸のスケーリングを固定
                
                ZStack {
                    // 背景のグリッド線を追加（Y 軸）
                    Path { path in
                        for i in stride(from: 0, through: maxY, by: 20) {
                            let y = height - (CGFloat(i) * stepY)
                            path.move(to: CGPoint(x: 0, y: y))
                            path.addLine(to: CGPoint(x: width-20, y: y))
                        }
                    }
                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    
                    // 背景のグリッド線を追加（X 軸）
                    Path { path in
                        for i in 0...12 {
                            let x = stepX * CGFloat(i)
                            path.move(to: CGPoint(x: x, y: 0))
                            path.addLine(to: CGPoint(x: x, y: height))
                        }
                    }
                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    
                    // グラフの描画
                    Path { path in
                        if !scores.isEmpty {
                            // 最初の点を描画
                            path.move(to: CGPoint(x: 0, y: height - 0))
                            
                            for (index, score) in scores.enumerated() {
                                let x = stepX * CGFloat(index+1)
                                let y = height - (CGFloat(score+tmp_score) * stepY)
                                tmp_score = score+tmp_score
                                path.addLine(to: CGPoint(x: x, y: y))
                            }
                        }
                    }
                    .stroke(Color.blue, lineWidth: 2)
                    // xlabels
                    ForEach(0...12, id: \.self) { num in
                        Text("\(num)")
                            .font(.caption)
                            .position(x:stepX * CGFloat(num), y: height+10)
                    }
                    // ylabels
                    ForEach(Array(stride(from: 0, through: 120, by: 20)), id: \.self) { num in
                        Text("\(num)")
                            .font(.caption)
                            .position(x:width, y: height - CGFloat(num) * stepY)
                    }
                }
                
                
            }
            .frame(height: 200)
            .padding()
        }
    }
}
