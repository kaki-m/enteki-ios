//
//  ContentView.swift
//  enteki-ios
//
//  Created by 柿崎愛斗 on 2023/09/30.
//

import SwiftUI
import SwiftSVG

struct ContentView: View {
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
                
                ArcheryTargetView() //的を表示
                    .navigationBarTitle("点数")
                    .navigationBarTitleDisplayMode(.inline)
                    .frame(maxWidth: .infinity,
                           maxHeight: .infinity)
                    .background(bodyColor)
                HitMarkView()// ヒットマーカーを表示
                    .background(Color.clear)
            }
                    }
        .navigationViewStyle(StackNavigationViewStyle()) //ipadで表示するため
        .background(bodyColor)
        .edgesIgnoringSafeArea(.all)
        TabBarView()
        
    }
}

struct TabBarView: View {
         
    var body: some View {
        TabView {
            Text("現在の点数表")
                .tabItem {
                    Image(systemName: "1.circle")
                    Text("First")
                }
            
            Text("Second Tab")
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
    @State private var positions: [CGPoint] = Array(repeating: .zero, count:12)  // 12個のヒットマーカーの座標を保存するための変数
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.white)
                .frame(width: 280, height: 280)
                .overlay(  //外枠に黒い線を表示
                    Circle()
                    .stroke(Color.black,lineWidth: 2)
                )
            Circle()
                .fill(Color.black)
                .frame(width: 224, height: 224)
            Circle()
                .fill(Color.blue)
                .frame(width: 168, height: 168)
            Circle()
                .fill(Color.red)
                .frame(width: 112, height: 112)
            Circle()
                .fill(Color.yellow)
                .frame(width: 56, height: 56)
        }
        .background(Color.clear)
        
    }
}

struct HitMarkView: View{
    @State private var positions: [CGPoint] = []  // 12個のヒットマークの座標を保存するための変数
    // let hitmarkColor = Color(red:255/255,green:200/255,blue:135/255)
    
    var body: some View{
        let hitmarkNum = 0
        let indexPosition = [1,1,1,2,2,2,3,3,3,4,4,4]  // indexを何本目かに変換するため
        ForEach(positions.indices, id: \.self){ index in
            if(index % 3 == 0){
                // 何本目かのテキストを決める
                var subtext = String(indexPosition[index])
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
                var subtext = String(indexPosition[index])
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
                var subtext = String(indexPosition[index])
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
                            positions.append(newHitMarkPosition)
                            print(positions)
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
