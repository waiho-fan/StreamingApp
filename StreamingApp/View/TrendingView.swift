//
//  MainView.swift
//  StreamingApp
//
//  Created by Gary on 21/2/2025.
//

import SwiftUI

struct TrendingView: View {
    @StateObject private var viewModel = TrendingViewModel()
    
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
                        ForEach(viewModel.trendShows) { show in
                            TrendingShowCard(show: show)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
        .background(Color.black)
        .task {
            viewModel.loadMockData()
        }
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
    @StateObject private var viewModel: TrendingShowCardViewModel
    
    init(show: Show) {
        _viewModel = StateObject(
            wrappedValue: TrendingShowCardViewModel(show: show)
        )
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // 海報圖片
            AsyncImage(url: URL(string: viewModel.getPosterURL() ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(2/3, contentMode: .fit)
                    .frame(maxWidth: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .shadow(radius: 8)
            } placeholder: {
                ProgressView()
            }
            
            VStack {
                // IMDb rating
                HStack {
                    Spacer()
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundStyle(.yellow)
                        Text("\(viewModel.show?.rating ?? 0)")
                            .bold()
                    }
                    .padding(8)
                    .background(.ultraThinMaterial.opacity(0.8))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                }
                .padding(8)

                Spacer()
                
                // title
                Text("\(viewModel.show?.title ?? "Not Given")")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.ultraThinMaterial.opacity(0.8))
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .padding(8)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.clear)
        }
        .frame(width: 200, height: 300)
    }
}

#Preview {
    TrendingView()
}
