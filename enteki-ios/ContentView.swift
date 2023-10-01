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
                    
                        VStack {
                            Image(systemName: "globe")
                                .imageScale(.large)
                                .foregroundStyle(.tint)
                            Text("Initial commit")
                        }
                        .navigationBarTitle("タイトル")
                        .navigationBarTitleDisplayMode(.inline)
                        .frame(maxWidth: .infinity,
                                   maxHeight: .infinity)
                        .background(bodyColor)
                    }
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
