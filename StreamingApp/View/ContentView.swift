//
//  ContentView.swift
//  StreamingApp
//
//  Created by Gary on 21/2/2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            MainView()
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
    }
}

#Preview {
    ContentView()
}
