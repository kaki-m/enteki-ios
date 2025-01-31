import SwiftUI

struct ScoreBoard: View {
    let rows = ["大前", "中", "落ち"]
    let columns = ["1", "2", "3", "4"]
    @EnvironmentObject var arrowData: ArrowData
    @State private var scores: [[String]] = [
        ["-", "-", "-", "-"],
        ["-", "-", "-", "-"],
        ["-", "-", "-", "-"]
    ]
    var body: some View {
        GeometryReader { geometry in
            let cellWidth = geometry.size.width / CGFloat(columns.count + 1) // セル幅を動的計算
            let cellHeight = geometry.size.height / CGFloat(rows.count + 2) // セル高さを動的計算
        
            VStack(spacing: 2) {
                // ヘッダー
                HStack(spacing: 2) {
                    Text("")
                        .frame(width: cellWidth-20, height: cellHeight) // 左上の空白セル
                    
                    ForEach(columns, id: \.self) { column in
                        Text(column)
                            .bold()
                            .frame(width: cellWidth-5, height: cellHeight)
                            .background(Color.gray.opacity(0.3))
                            .border(Color.black, width: 1)
                    }
                }

                // 本体
                ForEach(0..<rows.count, id: \.self) { row in
                    HStack(spacing: 2) {
                        Text(rows[row])
                            .bold()
                            .frame(width: cellWidth-20, height: cellHeight)
                            .background(Color.gray.opacity(0.3))
                            .border(Color.black, width: 1)

                        ForEach(0..<columns.count, id: \.self) { col in
                                Text(scores[row][col])
                                    .frame(width: cellWidth-5, height: cellHeight)
                                    .background(Color.white)
                                    .border(Color.black, width: 1)
                            }
                        }
                    }
                
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .padding()
            .onAppear(){
                updateScores()
            }
            .onChange(of: arrowData.scores) {
                updateScores()
            }
        }
    }
    func updateScores() {
        let scoreNum = arrowData.scores.count
        guard !arrowData.scores.isEmpty else { return } // scores が空なら何もしない
        if scoreNum > 0{
            scores[0][0] = "\(arrowData.scores[0])"
        }
        if scoreNum > 3{
            scores[0][1] = "\(arrowData.scores[3])"
        }
        if scoreNum > 6{
            scores[0][2] = "\(arrowData.scores[6])"
        }
        if scoreNum > 9{
            scores[0][3] = "\(arrowData.scores[9])"
        }
        if scoreNum > 1 {
            scores[1][0] = "\(arrowData.scores[1])"
        }
        if scoreNum > 4 {
            scores[1][1] = "\(arrowData.scores[4])"
        }
        if scoreNum > 7 {
            scores[1][2] = "\(arrowData.scores[7])"
        }
        if scoreNum > 10 {
            scores[1][3] = "\(arrowData.scores[10])"
        }
        if scoreNum > 2 {
            scores[2][0] = "\(arrowData.scores[2])"
        }
        if scoreNum > 5 {
            scores[2][1] = "\(arrowData.scores[5])"
        }
        if scoreNum > 8 {
            scores[2][2] = "\(arrowData.scores[8])"
        }
        if scoreNum > 11 {
            scores[2][3] = "\(arrowData.scores[11])"
        }
    }
}
