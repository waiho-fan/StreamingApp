//
//  MovieCardViewModel.swift
//  StreamingApp
//
//  Created by Gary on 22/2/2025.
//

import Foundation

class MovieCardViewModel: ObservableObject {
    private let searchViewModel: SearchViewModel
    let show: Show
    
    init (searchViewModel: SearchViewModel, show: Show) {
        self.searchViewModel = searchViewModel
        self.show = show
    }
    
    var formattedYear: String {
        guard let year = show.releaseYear else { return "Not Given" }
        
        let dateComponents = Calendar.current.dateComponents([.year], from: Date(timeIntervalSince1970: TimeInterval(year)))
        
        guard let date = Calendar.current.date(from: dateComponents) else { return String(year) }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        
        return formatter.string(from: date)
    }
    
    var posterURL: String? {
        searchViewModel.getPosterURL(for: show)
    }
    
}
