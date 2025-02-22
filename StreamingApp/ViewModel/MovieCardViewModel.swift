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
    
    var posterURL: String? {
        searchViewModel.getPosterURL(for: show)
    }
    
}
