//
//  ShowViewModel.swift
//  StreamingApp
//
//  Created by Gary on 19/2/2025.
//

import Foundation

@MainActor
class ShowViewModel: ObservableObject {
    @Published var show: Show
    @Published var selectedImageSize: Int = 480
    
    private let apiClient = ApiClient()
    
    init(show: Show, apiClietn: ApiClient = .init()) {
        self.show = show
    }
    
    var formattedGenres: String {
        show.genres.map { $0.name }.joined(separator: ", ")
    }
    
    func getPosterURL(isVertical: Bool = true) -> String? {
        if isVertical {
            return show.imageSet.verticalPoster.getImageURL(for: selectedImageSize)
        }
        return show.imageSet.horizontalPoster.getImageURL(for: selectedImageSize)
    }
    
    func loadMockData() {
        show = Show.mockShowFromJsonFile
    }
    
    func loadShowData() async {
        do {
            show = try await apiClient.fetchShow()
        } catch {
            print("error fetching show data: \(error)")
        }
    }
}
