//
//  SearchViewModel.swift
//  StreamingApp
//
//  Created by Gary on 22/2/2025.
//

import Foundation

// Category
enum ShowCategory: String, CaseIterable {
    case movies = "Movies"
    case tvSeries = "Tv Series"
    case documentary = "Documentary"
    case sports = "Sports"
}

//@MainActor
class SearchViewModel: ObservableObject {
    @Published var shows: [Show] = []
    @Published var filteredShows: [Show] = []
    @Published var selectedCategory: ShowCategory = .movies
    
    private let apiClient = ApiClient()
    
    init(apiClient: ApiClient = .init()) {
//        self.apiClient = apiClient
    }
    
    func getPosterURL(for show: Show, imageSize: Int = 480, isVertical: Bool = true) -> String? {
        return isVertical ? show.imageSet.verticalPoster.getImageURL(for: imageSize) : show.imageSet.horizontalPoster.getImageURL(for: imageSize)
    }
    
    func loadMockData() {
        let response: ShowResponse = Bundle.main.decode("shows.json")
        shows = response.shows
        filteredShows = shows
    }
    
    func loadShowData() async {
        do {
//            show = try await apiClient.fetchShow()
        } catch {
            print("error fetching show data: \(error)")
        }
    }
}
