import Foundation
import SQLite

class DatabaseManager {
    static let shared = DatabaseManager()
    private var db: Connection?

    private init() {
        do {
            let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let dbPath = documentDirectory.appendingPathComponent("score_database.sqlite3").path
            db = try Connection(dbPath)

            createTable()
        } catch {
            print("データベースの初期化に失敗しました: \(error)")
        }
    }

    private func createTable() {
        do {
            let scores = Table("scores")
            let id = SQLite.Expression<Int64>("id")
            let date = SQLite.Expression<String>("date")
            let positionData = SQLite.Expression<String>("arrowPositions")
            let score = SQLite.Expression<String>("scores")
            let targetCenterPosition = SQLite.Expression<String>("targetCenterPosition")
            let targetDiameter = SQLite.Expression<String>("targetDiameter")
            let scoreText = SQLite.Expression<String>("scoresText")
            let playerNames = SQLite.Expression<String>("playerNames")
            
            try db?.run(scores.create(ifNotExists: true) { t in
                t.column(id, primaryKey: .autoincrement)
                t.column(date)
                t.column(positionData)
                t.column(score)
                t.column(targetCenterPosition)
                t.column(targetDiameter)
                t.column(scoreText)
                t.column(playerNames)
            })
        } catch {
            print("テーブル作成に失敗しました: \(error)")
        }
    }

    func insertScoreRecord(date: String, positionData: String, score: String, targetCenterPosition: String, targetDiameter: String, scoreText: String, playerNames: String) {
        do {
            let scores = Table("scores")
            let dateColumn = SQLite.Expression<String>("date")
            let positionDataColumn = SQLite.Expression<String>("positionData")
            let scoreColumn = SQLite.Expression<String>("score")
            let targetCenterPositionColumn = SQLite.Expression<String>("targetCenterPosition")
            let targetDiameterColumn = SQLite.Expression<String>("targetDiameter")
            let scoreTextColumn = SQLite.Expression<String>("scoresText")
            let playerNamesColumn = SQLite.Expression<String>("playerNames")
            

            let insert = scores.insert(
                dateColumn <- date,
                positionDataColumn <- positionData,
                scoreColumn <- score,
                targetCenterPositionColumn <- targetCenterPosition,
                targetDiameterColumn <- targetDiameter,
                scoreTextColumn <- scoreText,
                playerNamesColumn <- playerNames
            )

            try db?.run(insert)

            print("スコアがデータベースに保存されました")
        } catch {
            print("スコアの保存に失敗しました: \(error)")
        }
    }
}
