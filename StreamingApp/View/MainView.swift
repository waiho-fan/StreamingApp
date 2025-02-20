//
//  MainView.swift
//  StreamingApp
//
//  Created by Gary on 21/2/2025.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // MARK: - Stream Everywhere
                HStack {
                    Text("Stream")
                        .foregroundStyle(.red)
                    Text("Everywhere")
                        .foregroundStyle(.white)
                }
                .font(.largeTitle)
                .bold()
                .padding(.horizontal)
                
                // MARK: - Continue Watching Card
                ContinueWatchingCard()
                    .padding(.horizontal)
                
                // MARK: - Trending
                Text("Trending")
                    .font(.title)
                    .bold()
                    .foregroundStyle(.white)
                    .padding(.horizontal)
                
                // MARK: - Trending Shows ScrollView
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(0..<5) { _ in
                            TrendingShowCard()
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
        .background(Color.black)
    }
}

// MARK: - Continue Watching Card 元件
struct ContinueWatchingCard: View {
    var body: some View {
        ZStack(alignment: .bottom) {
            // 背景圖片
            Image("image-horizontal-mock")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 24))
            
            // 播放按鈕和標題
//            HStack {
//                Image(systemName: "play.circle.fill")
//                    .font(.title2)
//                    .foregroundStyle(.red)
//                
//                VStack(alignment: .leading) {
//                    Text("Continue Watching")
//                        .font(.subheadline)
//                        .foregroundStyle(.gray)
//                    Text("Ready Player one")
//                        .font(.title3)
//                        .bold()
//                }
//                
//                Spacer()
//            }
//            .padding()
//            .background(.ultraThinMaterial)
//            .clipShape(RoundedRectangle(cornerRadius: 24))
//            .padding(8)
        }
    }
}

// MARK: - Trending Show Card 元件
struct TrendingShowCard: View {
    var body: some View {
        ZStack(alignment: .bottom) {
            // 海報圖片
            Image("image-vertical-mock")
                .resizable()
                .aspectRatio(2/3, contentMode: .fit)
                .frame(width: 200)
                .clipShape(RoundedRectangle(cornerRadius: 24))
                .shadow(radius: 8)

            // IMDb 評分
            HStack {
                Image(systemName: "star.fill")
                    .foregroundStyle(.yellow)
                Text("7.0")
                    .bold()
            }
            .padding(8)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(8)
            .offset(x: -60, y: -100)
            
            // 電影標題
            Text("Chernobyl")
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding()
                .frame(maxWidth: .infinity)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 24))
                .padding(8)
        }
    }
}

// MARK: - TabBar
struct CustomTabBar: View {
    var body: some View {
        HStack {
            Button(action: {}) {
                VStack {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .foregroundStyle(.red)
            }
            
            Spacer()
            
            Button(action: {}) {
                Image(systemName: "play.circle.fill")
                    .font(.system(size: 44))
                    .foregroundStyle(.gray)
            }
            
            Spacer()
            
            Button(action: {}) {
                VStack {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
                .foregroundStyle(.gray)
            }
        }
        .padding()
        .background(.black)
    }
}

// MARK: - 主視圖
struct MainTrendingView: View {
    var body: some View {
        ZStack(alignment: .bottom) {
            MainView()
            CustomTabBar()
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

#Preview {
    MainTrendingView()
}
