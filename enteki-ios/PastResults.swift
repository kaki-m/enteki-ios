import SwiftUI

struct PastResults: View {
    @EnvironmentObject var arrowData: ArrowData // 環境オブジェクトとして受け取る
    @State private var records: [(id: Int, date: String, score: String, playerNames: String)] = []
    @State private var dataExist: Bool = false // `@State` に変更
    @State private var showLoadMessage: Bool = false

    var body: some View {
        ZStack{
            VStack {
                if dataExist {
                    List(records, id: \.id) { record in
                        let scoreArray: [Int] = (try? JSONDecoder().decode([Int].self, from: record.score.data(using: .utf8)!)) ?? []
                        let playerNamesArray: [String] = (try? JSONDecoder().decode([String].self, from: record.playerNames.data(using: .utf8)!)) ?? []
                        VStack(alignment: .leading) {
                            Text("日付: \(record.date)")
                            Text("合計点: \(scoreArray.reduce(0,+))")
                            Text("\(playerNamesArray[0]), \(playerNamesArray[1]),  \(playerNamesArray[2])")
                        }
                        .padding()
                        .onTapGesture{
                            showLoadMessage = true
                            let pastResult = DatabaseManager.shared.fetchRecordById(id: record.id)!
                            arrowData.pastResultId = record.id
                            arrowData.recoredDateTime = pastResult.date
                            arrowData.scores = (try? JSONDecoder().decode([Int].self, from: pastResult.score.data(using: .utf8)!)) ?? []
                            arrowData.playerNames = (try? JSONDecoder().decode([String].self, from: pastResult.playerNames.data(using: .utf8)!)) ?? []
                            arrowData.targetCenterPosition = (try? JSONDecoder().decode(CGPoint.self, from: pastResult.targetCenterPosition.data(using: .utf8)!)) ?? CGPoint(x:0,y:0)
                            arrowData.targetDiameter = (try? JSONDecoder().decode(CGFloat.self, from: pastResult.targetDiameter.data(using: .utf8)!)) ?? CGFloat(0)
                            arrowData.scoresTexts = (try? JSONDecoder().decode([String].self, from: pastResult.scoreText.data(using: .utf8)!)) ?? []
                            arrowData.positions = (try? JSONDecoder().decode([CGPoint].self, from: pastResult.positionData.data(using: .utf8)!)) ?? []
                            arrowData.targetBackgroundColor = "blue"
                        }
                    }
                } else {
                    Text("データがありません")
                        .foregroundColor(.gray)
                        .padding()
                }
            }
            .onAppear {
                records = DatabaseManager.shared.fetchRecordsSummury() // `try` を削除
                dataExist = !records.isEmpty
            }
            if showLoadMessage {
                Text("過去データを読み込みました")
                    .padding()
                    .background(Color.black.opacity(0.7))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .opacity(showLoadMessage ? 1 : 0)
                    .animation(.easeInOut(duration: 0.5), value: showLoadMessage)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                showLoadMessage = false
                            }
                        }
                    }
            }
        }
    }
}
