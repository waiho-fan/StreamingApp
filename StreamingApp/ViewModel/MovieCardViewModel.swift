//
//  MovieCardViewModel.swift
//  StreamingApp
//
//  Created by Gary on 22/2/2025.
//

import Foundation

@MainActor
class MovieCardViewModel: ObservableObject {
    private let searchViewModel: SearchViewModel
    let show: Show
    
    init (searchViewModel: SearchViewModel, show: Show) {
        self.searchViewModel = searchViewModel
        self.show = show
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
    
    var posterURL: String? {
        searchViewModel.getPosterURL(for: show)
    }
    
}
