//
//  ContentView.swift
//  StreamingApp
//
//  Created by Gary on 19/2/2025.
//

import SwiftUI

struct TrendingView: View {
    let screenWidth = UIScreen.main.bounds.width
    @StateObject var viewModel: ShowViewModel = ShowViewModel(show: .mockLoadFromJsonFile)
    
    // 設置主要項目的寬度為螢幕寬度的 70%
    // 這樣左右兩邊會各顯示大約 15% 的下一個/上一個項目
    let mainItemWidth: CGFloat = UIScreen.main.bounds.width * 0.7
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 0) {
                // 添加初始間距，使第一個項目可以滾動到中間
                Spacer()
                    .frame(width: (screenWidth - mainItemWidth) / 2)
                
                ForEach(0..<5) { index in
                    GeometryReader { proxy in
                        let midX = proxy.frame(in: .global).midX
                        let rotation = calculateRotation(midX: midX)
                        let scale = calculateScale(midX: midX)
                        
                        AsyncImage(url: URL(string: viewModel.getPosterURL() ?? "")) { image in
                            image
                                .resizable()
                                .aspectRatio(2/3, contentMode: .fit)
                                .clipShape(RoundedRectangle(cornerRadius: 20.0))
                        } placeholder: {
                            ProgressView()
                        }
                        // 內容稍微小於容器，創造自然間距
                        .frame(width: mainItemWidth * 0.9)
                        .rotation3DEffect(.degrees(rotation), axis: (x: 0, y: 1, z: 0))
                        .scaleEffect(scale)
                        // 調整透明度範圍，使邊緣項目更加淡化
                        .opacity(scale * 0.7 + 0.3)
                        .shadow(radius: 5 * scale)
                    }
                    .frame(width: mainItemWidth)
                }
                
                // 添加結尾間距，使最後一個項目可以滾動到中間
                Spacer()
                    .frame(width: (screenWidth - mainItemWidth) / 2)
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.viewAligned)
        .frame(height: 400)
        .background(Color.gray.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .padding()
        .task {
            await viewModel.loadShowData()
        }
    }
    
    func calculateRotation(midX: CGFloat) -> Double {
        // 計算相對於螢幕中心的位置
        let screenCenter = screenWidth / 2
        let distanceFromCenter = midX - screenCenter
        
        // 將旋轉角度限制在較小的範圍內，使過渡更平滑
        let maxRotation: Double = 20
        
        // 使用正弦函數創造平滑的旋轉過渡
        let normalizedDistance = distanceFromCenter / (screenWidth / 2)
        let rotationAngle = -sin(normalizedDistance * .pi / 2) * maxRotation
        
        return rotationAngle
    }
    
    func calculateScale(midX: CGFloat) -> Double {
        let screenCenter = screenWidth / 2
        let distanceFromCenter = abs(midX - screenCenter)
        
        // 增加中心項目的最大縮放，使其更突出
        let maxScale: Double = 1.1
        let minScale: Double = 0.7
        
        // 使用指數函數使縮放更加動態
        let normalizedDistance = distanceFromCenter / (screenWidth / 2)
        let scale = maxScale - pow(normalizedDistance, 1.5) * (maxScale - minScale)
        
        return max(minScale, min(maxScale, scale))
    }
}

#Preview {
    TrendingView()
}
