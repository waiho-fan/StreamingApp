//
//  TrendingShowCardViewModel.swift
//  StreamingApp
//
//  Created by Gary on 22/2/2025.
//

import Foundation

class TrendingShowCardViewModel: ObservableObject {
    @Published var show: Show
    
    private let apiClient = ApiClient()
    
    init(show: Show) {
        self.show = show
    }
    
    func getPosterURL(imageSize: Int = 480, isVertical: Bool = true) -> String? {
        return isVertical
        ? self.show.imageSet.verticalPoster.getImageURL(for: imageSize)
        : self.show.imageSet.horizontalPoster.getImageURL(for: imageSize)
    }
    
    func loadMockData() {
        let response: Show = Bundle.main.decode("show.json")
        show = response
    }
    
    func loadShowData() async {
        do {
//            show = try await apiClient.fetchShow()
        } catch {
            print("error fetching show data: \(error)")
        }
    }
}
