import SwiftUI

struct PastResults: View {
    @State private var records: [(date: String, score: String, playerNames: String)] = []
    @State private var dataExist: Bool = false // `@State` に変更

    var body: some View {
        VStack {
            if dataExist {
                List(records, id: \.date) { record in
                    let scoreArray: [Int] = (try? JSONDecoder().decode([Int].self, from: record.score.data(using: .utf8)!)) ?? []
                    let playerNamesArray: [String] = (try? JSONDecoder().decode([String].self, from: record.playerNames.data(using: .utf8)!)) ?? []
                    VStack(alignment: .leading) {
                        Text("日付: \(record.date)")
                        Text("合計点: \(scoreArray.reduce(0,+))")
                        Text("\(playerNamesArray[0]), \(playerNamesArray[1]),  \(playerNamesArray[2])")
                    }
                    .padding()
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
    }
}
