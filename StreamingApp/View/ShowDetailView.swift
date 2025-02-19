//
//  ShowDetailView.swift
//  StreamingApp
//
//  Created by Gary on 19/2/2025.
//

import SwiftUI

struct ShowDetailView: View {
    @StateObject var viewModel: ShowViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // 海報圖片
                AsyncImage(url: URL(string: viewModel.getPosterURL() ?? "")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    ProgressView()
                }
                .frame(maxWidth: .infinity)
                
                // 標題和評分
                HStack {
                    Text(viewModel.show.title)
                        .font(.title)
                    Spacer()
                    RatingView(rating: viewModel.show.rating)
                }
                
                // 年份和集數資訊
                Text("\(viewModel.yearRange) • \(viewModel.show.episodeCount) Episodes")
                    .foregroundColor(.secondary)
                
                // 類型
                Text(viewModel.formattedGenres)
                    .font(.subheadline)
                
                // 概述
                Text(viewModel.show.overview)
                    .padding(.top)
                
                // 演員列表
                CastSection(cast: viewModel.show.cast)
            }
            .padding()
        }
    }
}

#Preview {
    let viewModel = ShowViewModel(show: Show.mock)
    ShowDetailView(viewModel: viewModel)
}
