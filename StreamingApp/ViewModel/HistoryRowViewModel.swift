//
//  HistoryRowViewModel.swift
//  StreamingApp
//
//  Created by Gary on 24/2/2025.
//

import Foundation

@MainActor
class HistoryRowViewModel: ObservableObject{
    let show: Show
    
    init(show: Show) {
        self.show = show
    }
    
    func getPosterURL(imageSize: Int = 720, isVertical: Bool = true) -> String? {
        return isVertical
        ? self.show.imageSet.verticalPoster.getImageURL(for: imageSize)
        : self.show.imageSet.horizontalPoster.getImageURL(for: imageSize)
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
}
