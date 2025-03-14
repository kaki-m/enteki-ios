//
//  ContentView.swift
//  enteki-ios
//
//  Created by 柿崎愛斗 on 2023/09/30.
//

import SwiftUI
import SwiftSVG

struct ContentView: View {
    @EnvironmentObject var arrowData: ArrowData // 環境オブジェクトとして受け取る
    @State private var showEmptyMessage: Bool = false
    @State private var showResetMessage: Bool = false
    @State private var showSaveMessage: Bool = false
    init() {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(red:52/255, green: 136/255, blue:00, alpha: 100)
            appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
    var body: some View {
        let color = colorByEnv(envColor:arrowData.targetBackgroundColor)
        let navigationColor = Color(uiColor: color)
        let bodyColor = Color(navigationColor.opacity(0.3))
        let topBarDate = formatDateTime(arrowData.recoredDateTime)
        let showdStatus = colorToStatus(color: arrowData.targetBackgroundColor)
            NavigationView {
                ZStack {
                    KyudoTargetView()
                        .navigationBarItems(
                                leading: Button(action: {
                                    print("初期化ボタンが押されました") // ここに処理を追加
                                    resetArrowData(saved: false)
                                }) {
                                    VStack(spacing: 2) {
                                                    Image(systemName: "arrow.uturn.backward")
                                                        .imageScale(.large) // 必要に応じてサイズ調整
                                                    Text("リセット")
                                                        .font(.caption)
                                                }
                                    .foregroundColor(.white)
                                },
                                trailing: Button(action: {  //結果保存ボタン
                                    saveData()
                                }){
                                    VStack(spacing: 2) {
                                                    Image(systemName: "square.and.arrow.down")
                                                        .imageScale(.large)
                                                    Text("保存")
                                                        .font(.caption)
                                                }
                                    .foregroundColor(.white)
                                })
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbarBackground(Color(navigationColor), for: .navigationBar)
                        .toolbarBackground(.visible, for: .navigationBar)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(bodyColor)
                        .toolbar {
                            ToolbarItem(placement: .principal) {
                                ZStack {
                                            HStack {
                                                Text(showdStatus)
                                                    .font(.subheadline)
                                                    .foregroundColor(.black)
                                                    .padding(.leading, 10) // 右側の余白を調整
                                                Spacer()
                                            }
                                            Text("\(arrowData.scores.reduce(0, +))点")
                                                .font(.system(size: 24, weight: .bold))

                                            HStack {
                                                Spacer()
                                                Text(topBarDate)
                                                    .font(.subheadline)
                                                    .foregroundColor(.black)
                                                    .padding(.trailing, 10) // 右側の余白を調整
                                            }
                                        }
                                        .frame(maxWidth: .infinity, alignment: .center) // 中央配置
                            }
                        }
                    
                    HitMarkView()
                        .background(Color.clear)
                    // 🔹 ふわっと表示して消えるメッセージ
                    if showEmptyMessage {
                        Text("矢所がありません")
                            .padding()
                            .background(Color.black.opacity(0.7))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .opacity(showEmptyMessage ? 1 : 0)
                            .animation(.easeInOut(duration: 0.5), value: showEmptyMessage)
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    withAnimation {
                                        showEmptyMessage = false
                                    }
                                }
                            }
                    }
                    if showResetMessage {
                        Text("矢所をリセットしました")
                            .padding()
                            .background(Color.black.opacity(0.7))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .opacity(showResetMessage ? 1 : 0)
                            .animation(.easeInOut(duration: 0.5), value: showResetMessage)
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    withAnimation {
                                        showResetMessage = false
                                    }
                                }
                            }
                    }
                    if showSaveMessage {
                        Text("矢所を保存しました")
                            .padding()
                            .background(Color.black.opacity(0.7))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .opacity(showSaveMessage ? 1 : 0)
                            .animation(.easeInOut(duration: 0.5), value: showSaveMessage)
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    withAnimation {
                                        showSaveMessage = false
                                    }
                                }
                            }
                    }
                }
            }
            .navigationViewStyle(StackNavigationViewStyle()) // iPad対応
            .background(bodyColor)
            .edgesIgnoringSafeArea(.all)
            
            TabBarView()
        }
        
    func hideKeyboard() {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        
    func resetArrowData(saved: Bool){
        if saved{
            showSaveMessage = true
        }else{
            showResetMessage = true
        }
        arrowData.pastResultId = -1
        arrowData.positions = []
        arrowData.scores = []
        arrowData.memo = ""
        arrowData.scoresTexts = ["-","-","-","-","-","-","-","-","-","-","-","-"]
        arrowData.targetBackgroundColor = "green"
        arrowData.recoredDateTime = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd HH:mm:ss" // フォーマット指定
            return formatter.string(from: Date()) // 現在の日時を文字列に変換
        }()
    }
    func saveData() {
        do {
            if arrowData.positions.isEmpty {
                withAnimation {
                    showEmptyMessage = true  // 🔹 エラーメッセージを表示
                }
                return
            }
            
            let dateString = arrowData.recoredDateTime
            let positionsString = try String(data: JSONEncoder().encode(arrowData.positions), encoding: .utf8) ?? ""
            let scoreString = try String(data: JSONEncoder().encode(arrowData.scores), encoding: .utf8) ?? ""
            let scoreTextsString = try String(data: JSONEncoder().encode(arrowData.scoresTexts), encoding: .utf8) ?? ""
            let playerNamesString = try String(data: JSONEncoder().encode(arrowData.playerNames), encoding: .utf8) ?? ""
            let targetCenterPositionString = "(\(arrowData.targetCenterPosition.x), \(arrowData.targetCenterPosition.y))"
            let targetDiameterString = "\(arrowData.targetDiameter)"
            if arrowData.targetBackgroundColor == "green" { // 背景がグリーンなら新規追加だからid指定せずに自動生成
                print("save without id")
                DatabaseManager.shared.insertScoreRecord(
                    date: dateString,
                    positionData: positionsString,
                    score: scoreString,
                    targetCenterPosition: targetCenterPositionString,
                    targetDiameter: targetDiameterString,
                    scoreText: scoreTextsString,
                    playerNames: playerNamesString,
                    memo: arrowData.memo
                )
            }else if arrowData.targetBackgroundColor == "blue" {
                print("save with id")
                DatabaseManager.shared.insertScoreRecord(
                    id: arrowData.pastResultId,
                    date: dateString,
                    positionData: positionsString,
                    score: scoreString,
                    targetCenterPosition: targetCenterPositionString,
                    targetDiameter: targetDiameterString,
                    scoreText: scoreTextsString,
                    playerNames: playerNamesString,
                    memo: arrowData.memo
                )
            }
            
            
            print("データ保存完了！")
        } catch {
            print("JSONエンコードに失敗しました: \(error)")
        }
        resetArrowData(saved: true)
    }
    func formatDateTime(_ dateTimeString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        inputFormatter.locale = Locale(identifier: "ja_JP") // 日本のロケール

        if let date = inputFormatter.date(from: dateTimeString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "MM/dd HH:mm"
            return outputFormatter.string(from: date)
        } else {
            return "変換失敗"
        }
    }
    func colorByEnv(envColor: String) -> UIColor {
        var returnColor: UIColor
        if envColor == "green" {
            returnColor = UIColor(red: 100/255, green: 170/255, blue: 100/255, alpha: 1.0) // 少し濃い緑
        } else if envColor == "blue" {
            returnColor = UIColor(red: 120/255, green: 170/255, blue: 230/255, alpha: 1.0) // 少し濃い青
        }else{
            returnColor = UIColor(red: 1/255, green: 1/255, blue: 1/255, alpha: 1.0)
        }
        return returnColor
    }
    func colorToStatus(color: String) -> String{
        var returnStatus: String
        if color == "green" {
            returnStatus = ""
        }else if color == "blue"{
            returnStatus = "過去データ"
        }else{
            returnStatus = "以上ステータス"
        }
        return returnStatus
        
    }
}


struct TabBarView: View {
    @EnvironmentObject var arrowData: ArrowData
    let tabItemSize: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 50 : 10
    init() {
            let appearance = UITabBarAppearance()
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.font: UIFont.systemFont(ofSize: tabItemSize)]
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.font: UIFont.boldSystemFont(ofSize: tabItemSize + 2)]
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }

    var body: some View {
        TabView {
            ScoreBoard()
                .tabItem {
                    Image(systemName: "tablecells")
                    Text("得点版")
                }

            Analysis()
                .tabItem {
                    Image(systemName: "chart.xyaxis.line")
                    Text("分析")
                }

            PastResults()
                .tabItem {
                    Image(systemName: "archivebox")
                    Text("過去データ")
                }
        }
        
        
    }
}


#Preview {
    let testArrowData = ArrowData() // モックデータを作成
    testArrowData.positions = [
        CGPoint(x: 100, y: 200),
        CGPoint(x: 150, y: 250),
        CGPoint(x: 200, y: 300),
        CGPoint(x: 250, y: 350),
        CGPoint(x: 300, y: 400)
    ]
    return ScoreBoard()
        .environmentObject(testArrowData) // 正しく `environmentObject` を渡す
}

struct KyudoTargetView: View {
    @EnvironmentObject var arrowData: ArrowData

    var body: some View {
        GeometryReader { geometry in
            let targetViewHeight : CGFloat = geometry.size.height
            ZStack {
                Circle()
                    .fill(Color.white)
                    .frame(width: arrowData.targetDiameter, height: arrowData.targetDiameter)
                    .overlay(
                        Circle()
                        .stroke(Color.black, lineWidth: 2)
                    )
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                    .onAppear {
                        arrowData.targetCenterPosition = CGPoint(x: geometry.size.width / 2,
                                                                y: geometry.size.height / 2)
                        if UIDevice.current.userInterfaceIdiom == .pad {
                            arrowData.targetDiameter = 500
                        }else{
                            arrowData.targetDiameter = targetViewHeight
                        }
                    }
                    .opacity(0.9)
                Circle()
                    .fill(Color.black)
                    .frame(width: (arrowData.targetDiameter / 5) * 4, height: (arrowData.targetDiameter / 5) * 4)
                    .opacity(0.9)
                Circle()
                    .fill(Color.blue)
                    .frame(width: (arrowData.targetDiameter / 5) * 3, height: (arrowData.targetDiameter / 5) * 3)
                    .opacity(0.9)
                Circle()
                    .fill(Color.red)
                    .frame(width: (arrowData.targetDiameter / 5) * 2, height: (arrowData.targetDiameter / 5) * 2)
                    .opacity(0.9)
                Circle()
                    .fill(Color.yellow)
                    .frame(width: arrowData.targetDiameter / 5, height: arrowData.targetDiameter / 5)
                    .opacity(0.9)
            }
            .background(Color.clear)
        }
        
    }
}


struct HitMarkView: View {
    @EnvironmentObject var arrowData: ArrowData
    let markSize: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 50 : 30
    let markTextSize: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 25 : 15

    var body: some View {
        GeometryReader { geometry in // ここで全体のサイズを取得
            ZStack {
                let indexPosition = [1,1,1,2,2,2,3,3,3,4,4,4]

                ForEach(arrowData.positions.indices, id: \.self) { index in
                    let subtext = String(indexPosition[index])
                    if index % 3 == 0 {
                        Image("Hitmark")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: markSize, height: markSize)
                            .position(x: arrowData.positions[index].x, y: arrowData.positions[index].y)
                            .gesture(
                                DragGesture(minimumDistance: 0)
                                    .onChanged { value in
                                        let newPosition = limitPosition(value.location, in: geometry.size)
                                        // print(index)
                                        arrowData.positions[index] = newPosition
                                        arrowData.scores[index] = scoreFromPosition(arrowData.positions[index])
                                        arrowData.scoresTexts[index] = scoreTextFromScore(arrowData.scores[index])
                                    }
                            )
                        Text("前")
                            .position(x: arrowData.positions[index].x+17, y:arrowData.positions[index].y-10 )
                            .foregroundColor(.brown)
                            .font(.system(size: markTextSize))
                            .bold()
                    }else if index % 3 == 1 {
                        Image("Hitmark")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: markSize, height: markSize)
                            .position(x: arrowData.positions[index].x, y: arrowData.positions[index].y)
                            .gesture(
                                DragGesture(minimumDistance: 0)
                                    .onChanged { value in
                                        let newPosition = limitPosition(value.location, in: geometry.size)
                                        arrowData.positions[index] = CGPoint(x: newPosition.x, y: newPosition.y)
                                        arrowData.scores[index] = scoreFromPosition(arrowData.positions[index])
                                        arrowData.scoresTexts[index] = scoreTextFromScore(arrowData.scores[index])
                                    }
                            )
                        Text("中")
                            .position(x: arrowData.positions[index].x+17, y:arrowData.positions[index].y-10 )
                            .foregroundColor(.brown)
                            .font(.system(size: markTextSize))
                            .bold()
                    }else{
                        Image("Hitmark")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: markSize, height: markSize)
                            .position(x: arrowData.positions[index].x, y: arrowData.positions[index].y)
                            .gesture(
                                DragGesture(minimumDistance: 0)
                                    .onChanged { value in
                                        let newPosition = limitPosition(value.location, in: geometry.size)
                                        arrowData.positions[index] = newPosition
                                        arrowData.scores[index] = scoreFromPosition(arrowData.positions[index])
                                        arrowData.scoresTexts[index] = scoreTextFromScore(arrowData.scores[index])
                                    }
                            )
                        Text("落")
                            .position(x: arrowData.positions[index].x+17, y:arrowData.positions[index].y-10)
                            .foregroundColor(.brown)
                            .font(.system(size: markTextSize))
                            .bold()
                    }
                    // 得点計算点の位置確認用
                    Circle()
                        .fill(Color.red)
                        .frame(width: 5, height: 5)
                        .position(arrowData.positions[index])
                    
                    
                    Text(subtext)
                        .position(x: arrowData.positions[index].x + 17, y: arrowData.positions[index].y + 10)
                        .foregroundColor(.brown)
                        .font(.system(size: markTextSize))
                }

                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            let newHitMarkPosition = CGPoint(x: geometry.size.width * 0.9, y: geometry.size.height * 0.8)
                            if arrowData.positions.count < 12 {
                                arrowData.positions.append(limitPosition(newHitMarkPosition, in: geometry.size))
                                arrowData.scores.append(scoreFromPosition(newHitMarkPosition))
                            }
                        }) {
                            Image(systemName: "plus.diamond")
                                .imageScale(.large)
                        }
                        .padding(15)
                    }
                }
            }
        }
    }

    // 追加：矢の移動範囲を制限する関数
    func limitPosition(_ position: CGPoint, in size: CGSize) -> CGPoint {
        let minX: CGFloat = size.width * 0 // 左端（的のエリア外に出ないように調整）
        let maxX: CGFloat = size.width * 1  // 右端
        let minY: CGFloat = size.height * 0.01 // 得点表の下から制限（矢が得点表に入らない）
        let maxY: CGFloat = size.height * 0.99 // 画面の下すぎないようにする

        let limitedX = min(max(position.x, minX), maxX)
        let limitedY = min(max(position.y, minY), maxY)

        return CGPoint(x: limitedX, y: limitedY)
    }
    
    func scoreFromPosition(_ position: CGPoint) -> Int {
        let center = arrowData.targetCenterPosition
        let diameter = arrowData.targetDiameter
        let radius = diameter / 2
        
        let distance = sqrt(pow(position.x - center.x, 2) + pow(position.y - (center.y+26), 2)) //なぜか上にずれるから手を加えた
        
        // ここで受け取ったポジション(表示用)を微調整(得点計算用へ)
        
        // 色ごとの半径閾値
        let yellowRadius = radius / 5
        let redRadius = radius * 2 / 5
        let blueRadius = radius * 3 / 5
        let blackRadius = radius * 4 / 5

        if distance <= yellowRadius {
            return 10 // 黄色
        } else if distance <= redRadius {
            return 9 // 赤
        } else if distance <= blueRadius {
            return 7 // 青
        } else if distance <= blackRadius {
            return 5 // 黒
        } else if distance <= radius {
            return 3 // 白
        } else {
            return 0 // 的の外
        }
    }
    func scoreTextFromScore(_ score: Int) -> String {
        switch score {
        case 10:
            return "yellow"
        case 9:
            return "red"
        case 7:
            return "blue"
        case 5:
            return "black"
        case 3:
            return "white"
        default:
            return "green"
        }
    }
    
}
