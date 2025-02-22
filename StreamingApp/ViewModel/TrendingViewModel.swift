//
//  TrendingViewModel.swift
//  StreamingApp
//
//  Created by Gary on 22/2/2025.
//

import Foundation

class TrendingViewModel: ObservableObject {
    @Published var trendShows: [Show] = []
    
    let apiClient: ApiClient = ApiClient()
    
    func loadMockData() {
        let responses: ShowResponse = Bundle.main.decode("shows.json")
        trendShows = responses.shows
    }
    
    func loadTrendingShowsData() async {
        do {
            trendShows = try await apiClient.fetchTrendShows()
        } catch {
            print("Trend shows data loading failed: \(error.localizedDescription)")
        }
    }
    
}
