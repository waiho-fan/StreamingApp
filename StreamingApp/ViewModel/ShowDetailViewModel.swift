//
//  ShowViewModel.swift
//  StreamingApp
//
//  Created by Gary on 19/2/2025.
//

import Foundation

@MainActor
class ShowDetailViewModel: ObservableObject {
    @Published var show: Show
    @Published var selectedImageSize: Int = 480
    
    private let apiClient = ApiClient()
    
    init(show: Show) {
        self.show = show
    }
    
    var formattedGenres: String {
        show.genres.map { $0.name }.joined(separator: ", ")
    }
    
    var formattedYear: String {
        if let year = show.releaseYear {
            return formatYear(year)
        } else if let firstAirYear = show.firstAirYear, let lastAirYear = show.lastAirYear{
            if firstAirYear == lastAirYear {
                return formatYear(firstAirYear)
            }
            return "\(formatYear(firstAirYear))-\(formatYear(lastAirYear))"
        } else {
            return "Not Given"
        }
    }
    
    func formatYear(_ year: Int) -> String {
        var components = Calendar.current.dateComponents([.year], from: Date())
        components.year = year
        
        guard let date = Calendar.current.date(from: components) else { return String(year) }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        
        return formatter.string(from: date)
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
            show = try await apiClient.fetchShow(imdbId: "tt0120338")
        } catch {
            print("error fetching show data: \(error)")
        }
    }
}
