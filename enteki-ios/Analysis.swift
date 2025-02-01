import SwiftUI

struct Analysis: View {
    @EnvironmentObject var arrowData: ArrowData

    var body: some View {
        GeometryReader { geometry in
            let scores: [Int] = arrowData.scores
            var tmp_score: Int = 0
            let width = geometry.size.width
            let height = geometry.size.height

            let maxX: CGFloat = 12  // X 軸を 1〜12 に固定
            let maxY: CGFloat = 120 // Y 軸を 0〜120 に固定

            let stepX = width / maxX  // X 軸の間隔を固定
            let stepY = height / maxY // Y 軸のスケーリングを固定

            ZStack {
                // 背景のグリッド線を追加（Y 軸）
                Path { path in
                    for i in stride(from: 0, through: maxY, by: 20) {
                        let y = height - (CGFloat(i) * stepY)
                        path.move(to: CGPoint(x: 0, y: y))
                        path.addLine(to: CGPoint(x: width, y: y))
                    }
                }
                .stroke(Color.gray.opacity(0.5), lineWidth: 1)

                // 背景のグリッド線を追加（X 軸）
                Path { path in
                    for i in 1...12 {
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
                        path.move(to: CGPoint(x: 1 * stepX, y: height -  CGFloat(scores[0]) * stepY))
                        tmp_score = scores[0]

                        for (index, score) in scores.enumerated().dropFirst() {
                            let x = stepX * CGFloat(index+1) // X 軸を 1 から始める
                            tmp_score = score+tmp_score
                            let y = height - (CGFloat(score+tmp_score) * stepY)
                            path.addLine(to: CGPoint(x: x, y: y))
                        }
                    }
                }
                .stroke(Color.blue, lineWidth: 2)
            }
            .overlay(
                // X 軸ラベル
                VStack {
                    Spacer()
                    HStack {
                        ForEach(1...12, id: \.self) { num in
                            Text("\(num)")
                                .font(.caption)
                                .frame(width: stepX, alignment: .center)
                        }
                    }
                }
                .frame(width: width, height: height, alignment: .bottom)
            )
            .overlay(
                // Y 軸ラベル
                HStack {
                    VStack {
                        ForEach(Array(stride(from: 0, through: 120, by: 20)), id: \.self) { num in
                            Text("\(num)")
                                .font(.caption)
                                .frame(height: stepY * 20)
                        }
                    }
                    Spacer()
                }
                .frame(width: width, height: height, alignment: .leading)
            )
        }
        .frame(height: 200)
        .padding()
    }
}
