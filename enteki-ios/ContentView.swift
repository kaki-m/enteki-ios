//
//  ContentView.swift
//  enteki-ios
//
//  Created by 柿崎愛斗 on 2023/09/30.
//

import SwiftUI

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
            
                        
                        ArcheryTargetView() //的を表示
                        .navigationBarTitle("点数")
                        .navigationBarTitleDisplayMode(.inline)
                        .frame(maxWidth: .infinity,
                                   maxHeight: .infinity)
                        .background(bodyColor)
                    }
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
