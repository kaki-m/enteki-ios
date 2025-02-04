//
//  enteki_iosApp.swift
//  enteki-ios
//
//  Created by 柿崎愛斗 on 2023/09/30.
//

import SwiftUI

// グローバル変数のように扱うためのクラスを定義
class ArrowData: ObservableObject {
    @Published var positions: [CGPoint] = []  // 矢の位置
    @Published var targetCenterPosition: CGPoint = CGPoint(x: -1, y: -1) // 的の中心座標
    @Published var targetDiameter: CGFloat = 280 // 的のサイズ
    @Published var scores: [Int] = []
    @Published var scoresTexts: [String] = ["-","-","-","-","-","-","-","-","-","-","-","-"]
    @Published var recoredDateTime: String = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss" // フォーマット指定
        return formatter.string(from: Date()) // 現在の日時を文字列に変換
    }()
    @Published var playerNames: [String] = ["大前", "中", "落ち"]
    @Published var targetBackgroundColor: String = "green"
    @Published var pastResultId: Int = -1
    @Published var memo: String = ""
}


@main
struct enteki_iosApp: App {
    @StateObject var arrowData = ArrowData() // アプリ全体で共有するデータ
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(arrowData)
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(ArrowData()) // 必要なら環境オブジェクトを渡す
}
