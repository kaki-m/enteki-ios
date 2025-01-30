import SwiftUI

struct ScoreBoard: View {
    let rows = ["大前", "中", "落ち"]
    let columns = ["1", "2", "3", "4"]

    @State private var scores: [[String]] = [
        ["10", "5", "-", "-"],
        ["0", "7", "-", "-"],
        ["8", "3", "-", "-"]
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
        }
    }
}
