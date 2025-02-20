//
//  ContentView.swift
//  StreamingApp
//
//  Created by Gary on 19/2/2025.
//

import SwiftUI

struct MainView: View {
    let shows: [Show] = Array(repeating: .mock, count: 10)
    @StateObject var viewModel: ShowViewModel = ShowViewModel(show: .mockLoadFromJsonFile)

    let scrollViewWidth = UIScreen.main.bounds.width

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(1..<20) { num in
                    GeometryReader { proxy in
                        let midX = proxy.frame(in: .global).midX
                        let rotation = calculateRotation(midX: midX, screenWidth: scrollViewWidth)
                        
                        // 計算縮放比例，讓中間的圖片略大一點
                        let scale = calculateScale(midX: midX, screenWidth: scrollViewWidth)
                        
                        AsyncImage(url: URL(string: viewModel.getPosterURL() ?? "")) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .clipShape(RoundedRectangle(cornerRadius: 20.0))
                                .rotation3DEffect(
                                    .degrees(rotation),
                                    axis: (x: 0, y: 1, z: 0)
                                )
                                .scaleEffect(scale) // 添加縮放效果
                                .opacity(scale * 0.8 + 0.2) // 添加透明度變化
                        } placeholder: {
                            ProgressView()
                        }
                        .padding(.horizontal)
                        .shadow(radius: 5 * scale)
                        .frame(width: 200, height: 300)
                    }
                    .frame(width: 200, height: 300)
                }
            }
//            .padding()
            .scrollTargetLayout()
        }
        .frame(height: .infinity)
        .background(Color.gray.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .padding()
        .scrollTargetBehavior(.viewAligned)
        .task {
            await viewModel.loadShowData()
        }
    }
    
    func calculateRotation(midX: CGFloat, screenWidth: CGFloat) -> Double {
        // 計算圖片中心點與螢幕中心的距離
        let screenCenter = screenWidth / 2
        let distanceFromCenter = midX - screenCenter
        
        // 設定最大旋轉角度
        let maxRotation: Double = 45
        
        // 計算旋轉角度：
        // - 當圖片在中間時，旋轉角度接近 0
        // - 當圖片在左邊時，得到正角度（向右旋轉）
        // - 當圖片在右邊時，得到負角度（向左旋轉）
        let rotationAngle = -Double(distanceFromCenter / screenCenter) * maxRotation
        
        // 使用 min 和 max 限制旋轉角度範圍
        return max(-maxRotation, min(maxRotation, rotationAngle))
    }
    
    func calculateScale(midX: CGFloat, screenWidth: CGFloat) -> Double {
        let screenCenter = screenWidth / 2
        let distanceFromCenter = abs(midX - screenCenter)
        let maxScale: Double = 1.1
        let minScale: Double = 0.8
        
        // 距離中心越近，縮放比例越大
        let scale = maxScale - (Double(distanceFromCenter) / Double(screenCenter)) * (maxScale - minScale)
        return max(minScale, min(maxScale, scale))
    }

}

#Preview {
    MainView()
}
