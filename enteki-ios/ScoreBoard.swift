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
            let viewWidth = geometry.size.width
        
            VStack(spacing: 0) {
                // ヘッダー
                HStack(spacing: 1) {
                    Text("")
                        .frame(width: cellWidth-20, height: 25) // 左上の空白セル
                    
                    ForEach(columns, id: \.self) { column in
                        Text(column)
                            .bold()
                            .frame(width: cellWidth-5, height: 25)
                            .cornerRadius(3)
                    }
                }

                // 本体
                ForEach(0..<rows.count, id: \.self) { row in
                    HStack(spacing: 1) {
                        ZStack(alignment: .trailing) { // 右寄せ配置
                            TextField(rows[row], text: $arrowData.playerNames[row])
                                .bold()
                                .padding(.leading, 5) // 文字の開始位置をボーダーの右にずらす
                                .frame(width: cellWidth - 20, height: cellHeight + 8)
                                .background(Color.gray.opacity(0.5))
                                .border(Color.black, width: 2)
                                .cornerRadius(3)
                                .disableAutocorrection(true)
                            
                            Image(systemName: "pencil") // 鉛筆アイコン
                                .foregroundColor(.gray)  // 色
                                .padding(.trailing, 5)   // 右端の余白
                                .padding(.bottom, 15)     // 下端の余白（位置調整）
                        }
                            

                        ForEach(0..<columns.count, id: \.self) { col in
                                Text(scores[row][col])
                                    .frame(width: cellWidth-5, height: cellHeight+8)
                                    // 得点ごとの色に背景色を設定
                                    .background(backgroundColor(for: row, col: col))
                                    .border(Color.black, width: 2)
                                    .cornerRadius(3)
                            }
                        }
                    }
                
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                TextField("メモ欄", text: $arrowData.memo)
                    .padding(.leading, 5)
                    .frame(width:viewWidth*0.9, height: 40)
                    .border(Color.black, width: 2)
                    .cornerRadius(5)
                    
            }
            .padding(EdgeInsets(top: 1, leading: 1, bottom: 1, trailing: 1))
            .onAppear(){
                updateScores()
            }
            .onChange(of: arrowData.scores) {
                updateScores()
            }
            .onChange(of: arrowData.recoredDateTime){
                resetScores()
            }
            .onTapGesture {
                    hideKeyboard()
            }
            .simultaneousGesture(TapGesture().onEnded {
                hideKeyboard()
            })
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
    func resetScores(){
        scores = [
            ["-", "-", "-", "-"],
            ["-", "-", "-", "-"],
            ["-", "-", "-", "-"]
        ]
    }
    func backgroundColor(for row: Int, col: Int) -> Color {
        guard let score = Int(scores[row][col]) else { return Color.gray.opacity(0.3)}
            
        switch score {
        case 0:
            return Color.green.opacity(0.3)
        case 3:
            return Color.white.opacity(0.3)
        case 5:
            return Color.black.opacity(0.3)
        case 7:
            return Color.blue.opacity(0.3)
        case 9:
            return Color.red.opacity(0.3)
        case 10:
            return Color.yellow.opacity(0.3)
        default:
            return Color.gray.opacity(0.05)
            }
        }
    func hideKeyboard() {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    
}
