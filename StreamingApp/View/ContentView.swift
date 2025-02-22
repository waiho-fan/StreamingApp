//
//  ContentView.swift
//  StreamingApp
//
//  Created by iOS Dev Ninja on 21/2/2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            TrendingView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            SearchView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
            HistoryView()
                .tabItem {
                    Image(systemName: "clock")
                    Text("History")
                }
        }
        .onAppear {
            // Set unselected color
            let appearance = UITabBarAppearance()
            appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
            appearance.backgroundColor = UIColor.black
            
            appearance.stackedLayoutAppearance.normal.iconColor = .gray
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.gray]
            
            // Set selected color
            appearance.stackedLayoutAppearance.selected.iconColor = .red
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.red]
            
            // Set tab bar
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}

#Preview {
    ContentView()
}
