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
    let memo = SQLite.Expression<String>("memo")

    private init() {
        // デバッグでデータベースを初期化する>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
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
                t.column(memo)
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

    func insertScoreRecord(id: Int? = nil, date: String, positionData: String, score: String, targetCenterPosition: String, targetDiameter: String, scoreText: String, playerNames: String, memo: String) {
        do {
            let scores = Table("scores")
            let idColumn = SQLite.Expression<Int64>("id")
            let dateColumn = SQLite.Expression<String>("date")
            let positionDataColumn = SQLite.Expression<String>("positionData")
            let scoreColumn = SQLite.Expression<String>("score")
            let targetCenterPositionColumn = SQLite.Expression<String>("targetCenterPosition")
            let targetDiameterColumn = SQLite.Expression<String>("targetDiameter")
            let scoreTextColumn = SQLite.Expression<String>("scoreText")
            let playerNamesColumn = SQLite.Expression<String>("playerNames")
            let memoColumn = SQLite.Expression<String>("memo")

            if let id = id {
                // 既存のIDがある場合はUPSERT (idを指定して更新or挿入)
                let insert = scores.insert(or: .replace,
                    idColumn <- Int64(id),
                    dateColumn <- date,
                    positionDataColumn <- positionData,
                    scoreColumn <- score,
                    targetCenterPositionColumn <- targetCenterPosition,
                    targetDiameterColumn <- targetDiameter,
                    scoreTextColumn <- scoreText,
                    playerNamesColumn <- playerNames,
                    memoColumn <- memo
                )

                try db?.run(insert)
                print("スコア（id:\(id)）がデータベースに保存（または更新）されました")
            } else {
                // idが指定されていない場合は通常のinsert (idは自動生成)
                let insert = scores.insert(
                    dateColumn <- date,
                    positionDataColumn <- positionData,
                    scoreColumn <- score,
                    targetCenterPositionColumn <- targetCenterPosition,
                    targetDiameterColumn <- targetDiameter,
                    scoreTextColumn <- scoreText,
                    playerNamesColumn <- playerNames,
                    memoColumn <- memo
                )

                let insertedId = try db?.run(insert)
                print("新しいスコアがデータベースに保存されました（id: \(insertedId ?? -1)）")
            }

        } catch {
            print("スコアの保存（または更新）に失敗しました: \(error)")
        }
    }
    func fetchRecordsSummury() -> [(id: Int, date: String, score: String, playerNames: String, memo:String)] {
        var records: [(id:Int, date: String, score: String, playerNames: String, memo: String)] = []

        do {
            let scores = Table("scores")
            let idColumn = SQLite.Expression<Int>("id")
            let dateColumn = SQLite.Expression<String>("date")
            let scoreColumn = SQLite.Expression<String>("score")
            let playerNamesColumn = SQLite.Expression<String>("playerNames")
            let memoColumn = SQLite.Expression<String>("memo")

            for record in try db!.prepare(scores) {
                let id = record[idColumn]
                let date = record[dateColumn]
                let score = (try? record.get(scoreColumn)) ?? ""
                let playerNames = record[playerNamesColumn]
                let memo = record[memoColumn]

                records.append((id, date, score, playerNames, memo))
            }
        } catch {
            print("データ取得に失敗しました: \(error)")
        }
        
        return records
    }
    func fetchRecordById(id: Int) -> (date: String, positionData: String, score: String, targetCenterPosition: String, targetDiameter: String, scoreText: String, playerNames: String, memo: String)? {
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
            let memoColumn = SQLite.Expression<String>("memo")
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
                let memo = record[memoColumn]
                return (date, positionData, score, targetCenterPosition, targetDiameter, scoreText,playerNames, memo)
            }
        }catch{
            print("id:\(id)のデータ取得に失敗")
            return nil
        }
        return nil
    }

}
