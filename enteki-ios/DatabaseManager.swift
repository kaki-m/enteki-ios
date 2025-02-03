import Foundation
import SQLite

class DatabaseManager {
    static let shared = DatabaseManager()
    private var db: Connection?
    let scores = Table("scores")
    let id = SQLite.Expression<Int64>("id")
    let date = SQLite.Expression<String>("date")
    let positionData = SQLite.Expression<String>("positionData")
    let score = SQLite.Expression<String>("score")
    let targetCenterPosition = SQLite.Expression<String>("targetCenterPosition")
    let targetDiameter = SQLite.Expression<String>("targetDiameter")
    let scoreText = SQLite.Expression<String>("scoreText")
    let playerNames = SQLite.Expression<String>("playerNames")

    private init() {
//        // デバッグでデータベースを初期化する>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//        do {
//            let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//            let dbPath = documentDirectory.appendingPathComponent("score_database.sqlite3").path
//
//            // データベースファイルを削除
//            try FileManager.default.removeItem(atPath: dbPath)
//            print("データベースを削除しました")
//
//        } catch {
//            print("データベースの削除に失敗しました: \(error)")
//        }
        //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<ここまで
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
            try db?.run(scores.create(ifNotExists: true) { t in
                t.column(id, primaryKey: .autoincrement)
                t.column(date)
                t.column(positionData)
                t.column(score, defaultValue: "")
                t.column(targetCenterPosition)
                t.column(targetDiameter)
                t.column(scoreText)
                t.column(playerNames)
            })
            do {
                try db?.run("UPDATE scores SET score = '' WHERE score IS NULL")
            } catch {
                print("NULL 値の修正に失敗しました: \(error)")
            }
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
            let scoreTextColumn = SQLite.Expression<String>("scoreText")
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
    func fetchRecordsSummury() -> [(id: Int, date: String, score: String, playerNames: String)] {
        var records: [(id:Int, date: String, score: String, playerNames: String)] = []

        do {
            let scores = Table("scores")
            let idColumn = SQLite.Expression<Int>("id")
            let dateColumn = SQLite.Expression<String>("date")
            let scoreColumn = SQLite.Expression<String>("score")
            let playerNamesColumn = SQLite.Expression<String>("playerNames")

            for record in try db!.prepare(scores) {
                let id = record[idColumn]
                let date = record[dateColumn]
                let score = (try? record.get(scoreColumn)) ?? ""
                let playerNames = record[playerNamesColumn]

                records.append((id, date, score, playerNames))
            }
        } catch {
            print("データ取得に失敗しました: \(error)")
        }
        
        return records
    }
    func fetchRecordById(id: Int) -> (date: String, positionData: String, score: String, targetCenterPosition: String, targetDiameter: String, scoreText: String, playerNames: String)? {
        do{
            let scores = Table("scores")
            let idColumn = SQLite.Expression<Int>("id")
            let dateColumn = SQLite.Expression<String>("date")
            let positionDataColumn = SQLite.Expression<String>("positionData")
            let scoreColumn = SQLite.Expression<String>("score")
            let targetCenterPositionColumn = SQLite.Expression<String>("targetCenterPosition")
            let targetDiameterColumn = SQLite.Expression<String>("targetDiameter")
            let scoreTextColumn = SQLite.Expression<String>("scoreText")
            let playerNamesColumn = SQLite.Expression<String>("playerNames")
            let query = scores.filter(idColumn == id)
            guard let db = db else {
                    print("データベース接続がありません")
                return nil
            }
            if let record = try db.pluck(query){
                let date = record[dateColumn]
                let positionData = record[positionDataColumn]
                let score = record[scoreColumn]
                let targetCenterPosition = record[targetCenterPositionColumn]
                let targetDiameter = record[targetDiameterColumn]
                let scoreText = record[scoreTextColumn]
                let playerNames = record[playerNamesColumn]
                return (date, positionData, score, targetCenterPosition, targetDiameter, scoreText,playerNames)
            }
        }catch{
            print("id:\(id)のデータ取得に失敗")
            return nil
        }
        return nil
    }

}
