//
//  SearchViewModel.swift
//  StreamingApp
//
//  Created by Gary on 22/2/2025.
//

import Foundation

// Category
enum ShowCategory: String, CaseIterable {
    case all = "All"
    case movies = "Movies"
    case episode = "Episode"
    case documentary = "Documentary"
    case sports = "Sports"
    
    var showType: String {
        switch self {
        case .movies:
            return "movie"
        case .episode:
            return "series"
        default:
            return ""
        }
    }
}

@MainActor
class SearchViewModel: ObservableObject {
    @Published private(set) var isLoading = false

    @Published var shows: [Show] = []
    @Published var filteredShows: [Show] = []
    @Published var searchText = "" {
        didSet {
            Task {
                await loadShowDataForTitle(title: searchText, category: selectedCategory)
            }
        }
    }
    @Published var selectedCategory: ShowCategory = .all {
        didSet {
            Task {
                await loadShowDataForFilter(keyword: searchText, category: selectedCategory)
            }
        }
    }
    
    private let apiClient = ApiClient()
    
    init() {}
    
    func getPosterURL(for show: Show, imageSize: Int = 480, isVertical: Bool = true) -> String? {
        return isVertical ? show.imageSet.verticalPoster.getImageURL(for: imageSize) : show.imageSet.horizontalPoster.getImageURL(for: imageSize)
    }
    
    func loadMockData() {
        let response: ShowResponse = Bundle.main.decode("shows.json")
        shows = response.shows
        filteredShows = shows
    }
    
    func loadShowDataForFilter(keyword: String = "", category: ShowCategory = .all) async {
        do {
            let fetchedShows = try await apiClient.fetchShowsBySearchFilter(
                country: "hk",
                catalogs: ["netflix"],
                keyword: keyword,
                showType: category.showType
            )
            
            self.shows = fetchedShows
        } catch {
            print("error fetching show data: \(error)")
        }
    }
    
    func loadShowDataForTitle(title: String, category: ShowCategory = .all) async {
        do {
            let fetchedShows = try await apiClient.fetchShowsBySearchTitle(
                title: title,
                showType: category.showType
            )
            
            self.shows = fetchedShows
        } catch {
            print("error fetching show data: \(error)")
        }
    }
}
