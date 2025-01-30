import SwiftUI

struct ScoreBoard: View {
    @EnvironmentObject var arrowData: ArrowData
    
    let rows = ["大前", "中", "落ち"]
    let columns = [1, 2, 3, 4]

    var body: some View {
        VStack {
            Text("得点表")
                .font(.headline)

            // 得点表の作成
                    GridStack(rows: 3, columns: 3) { row, column in
                        Text("\(row), \(column)")
                            .frame(width: 60, height: 60)
                            .background(Color.yellow)
            }
            .padding()
            .border(Color.black, width: 2)
        }
    }
    
    // 矢のスコアを計算する関数（仮実装）
    func getScore(for position: CGPoint) -> Int {
        return Int.random(in: 0...10) // ここではランダム（実際には座標を分析して決定）
    }
}

// 汎用的なGridStackを定義
struct GridStack<Content: View>: View {
    let rows: Int
    let columns: Int
    let content: (Int, Int) -> Content
    
    var body: some View {
        VStack(spacing: 5) {
            ForEach(0..<rows, id: \.self) { row in
                HStack(spacing: 5) {
                    ForEach(0..<columns, id: \.self) { column in
                        content(row, column)
                            .frame(width: 60, height: 60)
                            .border(Color.gray, width: 1)
                    }
                }
            }
        }
    }
}
