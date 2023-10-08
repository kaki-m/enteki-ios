//
//  ContentView.swift
//  enteki-ios
//
//  Created by 柿崎愛斗 on 2023/09/30.
//

import SwiftUI
import SwiftSVG

struct ContentView: View {
    @State private var positions: [CGPoint] = []  // 12個のヒットマークの座標を保存するための変数
    @State private var targetCenterPosition: CGPoint = CGPoint(x:-1,y:-1) // 的の中心座標を共有するための変数
    @State private var targetDiameter: CGFloat = 280
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
        let color = UIColor(red: 122/255, green: 191/255, blue: 120/255, alpha: 1.0)
        let bodyColor = Color(uiColor: color)
        NavigationView {
            ZStack{
                
                ArcheryTargetView(targetCenterPosition: $targetCenterPosition, targetDiameter: $targetDiameter) //的を表示
                    .navigationBarTitle("点数")
                    .navigationBarTitleDisplayMode(.inline)
                    .frame(maxWidth: .infinity,
                           maxHeight: .infinity)
                    .background(bodyColor)
                HitMarkView(positions: $positions)// ヒットマーカーを表示
                    .background(Color.clear)
            }
                    }
        .navigationViewStyle(StackNavigationViewStyle()) //ipadで表示するため
        .background(bodyColor)
        .edgesIgnoringSafeArea(.all)
        TabBarView(positions: $positions,
                   targetCenterPosition: $targetCenterPosition,
                   targetDiameter: $targetDiameter)
        
    }
}

struct TabBarView: View {
    @Binding var positions: [CGPoint]  // ヒットマークの位置を共有(12個まで)
    @Binding var targetCenterPosition: CGPoint  // 中心からヒットマークの距離でどこに当たったのかを計算
    @Binding var targetDiameter: CGFloat  // 直径の大きさを共有(ここから黄色の範囲や青の範囲を計算する
    var body: some View {
        let testPositionStr = String(positions.count)
        let targetCenterPositionStr = "(\(targetCenterPosition))"
        TabView {
            Text(testPositionStr)
                .tabItem {
                    Image(systemName: "1.circle")
                    Text("点数表")
                }
            
            Text(targetCenterPositionStr)
                .tabItem {
                    Image(systemName: "2.circle")
                    Text("Second")
                }
            .badge(5)

            
            Text("Third Tab")
                .tabItem {
                    Image(systemName: "3.circle")
                    Text("Third")
                }
            .badge("New")
        }
    }
}

#Preview {
    ContentView()
}

struct ArcheryTargetView: View {
    @Binding var targetCenterPosition: CGPoint  // 的の中心座標をContentViewに伝えるために受け取る
    @Binding var targetDiameter: CGFloat  // 的の直径を共有
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Circle()
                    .fill(Color.white)
                    .frame(width: targetDiameter, height: targetDiameter)
                    .overlay(  //外枠に黒い線を表示
                        Circle()
                        .stroke(Color.black,lineWidth: 2)
                    )
                    .position(x: geometry.size.width/2, y: geometry.size.height/2)
                    .onAppear {  // 出現時に中央の座標を共有する
                        let rect = geometry.frame(in: .local)
                        targetCenterPosition = CGPoint(x: rect.midX, y: rect.midY)
                    }
                Circle()
                    .fill(Color.black)
                    .frame(width: (targetDiameter/5)*4, height: (targetDiameter/5)*4)
                Circle()
                    .fill(Color.blue)
                    .frame(width: (targetDiameter/5)*3, height: (targetDiameter/5)*3)
                Circle()
                    .fill(Color.red)
                    .frame(width: (targetDiameter/5)*2, height: (targetDiameter/5)*2)
                Circle()
                    .fill(Color.yellow)
                    .frame(width: targetDiameter/5, height: targetDiameter/5)
            }
            .background(Color.clear)
        }
    }
}

struct HitMarkView: View{
    @Binding var positions: [CGPoint]  // ContentViewから持ってくる
    var body: some View{
        let indexPosition = [1,1,1,2,2,2,3,3,3,4,4,4]  // indexを何本目かに変換するため
        ForEach(positions.indices, id: \.self){ index in
            if(index % 3 == 0){
                // 何本目かのテキストを決める
                let subtext = String(indexPosition[index])
                Image("OomaeHitmark")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width:20, height:20)
                    .position(x:positions[index].x, y:positions[index].y)
                    .gesture(
                        DragGesture(minimumDistance:0)
                            .onChanged{value in
                                self.positions[index] = value.location
                            }
                            .onEnded{ value in
                                self.positions[index] = value.location
                            })
                
                Text(subtext)
                    .position(x:positions[index].x+10, y:positions[index].y+10)
                    .foregroundColor(.brown)
            }
            else if(index % 3 == 1){
                // 何本目かのテキストを決める
                let subtext = String(indexPosition[index])
                Image("NakaHitmark")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width:20, height:20)
                    .position(x:positions[index].x, y:positions[index].y)
                    .gesture(
                        DragGesture(minimumDistance:0)
                            .onChanged{value in
                                self.positions[index] = value.location
                            }
                            .onEnded{ value in
                                self.positions[index] = value.location
                            })
                Text(subtext)
                    .foregroundColor(.brown)
                    .position(x:positions[index].x+10, y:positions[index].y+10)
            }else if(index % 3 == 2){
                // 何本目かのテキストを決める
                let subtext = String(indexPosition[index])
                Image("OtiHitmark")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width:20, height:20)
                    .position(x:positions[index].x, y:positions[index].y)
                    .gesture(
                        DragGesture(minimumDistance:0)
                            .onChanged{value in
                                self.positions[index] = value.location
                            }
                            .onEnded{ value in
                                self.positions[index] = value.location
                            })
                Text(subtext)
                    .position(x:positions[index].x+10, y:positions[index].y+10)
                    .foregroundColor(.brown)
            }
        }
        // タップしたときに増えるヒットマークを増やす
        VStack{
            Spacer()
            GeometryReader{ geometry in
                VStack{
                    Spacer()
                    HStack{
                        Spacer()
                        Button(action:{
                            let newHitMarkPosition = CGPoint(x: geometry.size.width / 1.15, y: geometry.size.height / 1.15)
                            if(positions.count < 12){
                                positions.append(newHitMarkPosition)
                                print(positions)
                            }else{
                                print("すでにマークは12個出ています")
                            }
                        },label: {
                            Image(systemName:"plus.diamond")
                        })
                        .padding(15)
                }
                
            
                }
            }
        }
        
    }
}


