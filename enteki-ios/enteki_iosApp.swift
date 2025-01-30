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
