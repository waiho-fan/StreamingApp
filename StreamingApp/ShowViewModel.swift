//
//  ShowViewModel.swift
//  StreamingApp
//
//  Created by Gary on 19/2/2025.
//

import Foundation

class ShowViewModel: ObservableObject {
    @Published var show: Show
    @Published var selectedImageSize: Int = 480
    
    init(show: Show) {
        self.show = show
    }
    
    var formattedGenres: String {
        show.genres.map { $0.name }.joined(separator: ", ")
    }
    
    var yearRange: String {
        if show.firstAirYear == show.lastAirYear {
            return "\(show.firstAirYear)"
        }
        return "\(show.firstAirYear)-\(show.lastAirYear)"
    }
    
    func getPosterURL(isVertical: Bool = true) -> String? {
        if isVertical {
            return show.imageSet.verticalPoster.getImageURL(for: selectedImageSize)
        }
        return show.imageSet.horizontalPoster.getImageURL(for: selectedImageSize)
    }
}
