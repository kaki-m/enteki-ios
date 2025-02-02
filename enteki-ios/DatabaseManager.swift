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
            let positionData = SQLite.Expression<String>("positionData")
            let score = SQLite.Expression<Int>("score")

            try db?.run(scores.create(ifNotExists: true) { t in
                t.column(id, primaryKey: .autoincrement)
                t.column(date)
                t.column(positionData)
                t.column(score)
            })
        } catch {
            print("テーブル作成に失敗しました: \(error)")
        }
    }

    func insertScoreRecord(date: String, positionData: String, score: Int) {
        do {
            let scores = Table("scores")
            let dateColumn = SQLite.Expression<String>("date")
            let positionDataColumn = SQLite.Expression<String>("positionData")
            let scoreColumn = SQLite.Expression<Int>("score")

            let insert = scores.insert(
                dateColumn <- date,
                positionDataColumn <- positionData,
                scoreColumn <- score
            )

            try db?.run(insert)

            print("スコアがデータベースに保存されました")
        } catch {
            print("スコアの保存に失敗しました: \(error)")
        }
    }
}
