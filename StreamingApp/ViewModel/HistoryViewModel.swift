//
//  HistoryViewModel.swift
//  StreamingApp
//
//  Created by Gary on 24/2/2025.
//

import Foundation
import SwiftUI

class HistoryViewModel: ObservableObject {
    @Published var watchHistory: [Show] = []
    private let userDefaults = UserDefaults.standard
    private let historyKey = "WatchHistory"
    @Published var isEditing: Bool = false
    
    @Published var filteredHistory: [Show] = []
    @Published var sortOption: SortOption = .dateAdded {
        didSet {
            applyFilterAndSort()
        }
    }
    @Published var filterOption: FilterOption = .all {
        didSet {
            applyFilterAndSort()
        }
    }
    @Published var searchText: String = ""
    
    init() {
        loadHistory()
    }
    
    enum SortOption: String, CaseIterable  {
        case dateAdded
        case title
        case year
        
        var stringValue: String {
            switch self {
            case .dateAdded:
                return "Date Added"
            case .title:
                return "Title"
            case .year:
                return "Year"
            }
        }
    }
    
    enum FilterOption {
        case all
        case thisYear
        case lastYear
        case custom(String)
    }
    
    //MARK: - Public
    func adddToHistory(_ show: Show) {
        if !watchHistory.contains(where: { $0.id == show.id }) {
            watchHistory.insert(show, at: 0)
            saveHistory()
        }
    }
    
    func clearHistory() {
        watchHistory.removeAll()
        userDefaults.removeObject(forKey: historyKey)
    }
    
    func deleteShow(_ show: Show) {
        withAnimation {
            watchHistory.removeAll { $0.id == show.id }
            filteredHistory.removeAll { $0.id == show.id }
            
            saveHistory()
            applyFilterAndSort()
        }
    }
    
    func deleteShows(at offsets: IndexSet) {
        let showsToDelete = offsets.map { watchHistory[$0] }
        
        for show in showsToDelete {
            watchHistory.remove(atOffsets: offsets)
            filteredHistory.removeAll { $0.id == show.id }
        }
        saveHistory()
    }
    
    //MARK: - Private
    func loadHistory() {
        print("Loading history...")
//        watchHistory = Show.mockShowsFromJsonFile
        
        if let savedData = userDefaults.data(forKey: historyKey) {
            if let history = try? JSONDecoder().decode([Show].self, from: savedData) {
                watchHistory = history
                filteredHistory = watchHistory
                
                applyFilterAndSort()
            }
        }
    }
    
    func saveHistory() {
        if let savedData = try? JSONEncoder().encode(watchHistory) {
            userDefaults.set(savedData, forKey: historyKey)
        }
    }
}

extension HistoryViewModel {
    func applyFilterAndSort() {
        var result = filterHistory()
        
        sortHistory(&result)
        
        filteredHistory = result
    }
    
    private func filterHistory() -> [Show] {
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: Date())
        
        return watchHistory.filter { show in
            switch filterOption {
            case .all:
                return true
            case .thisYear:
                return show.releaseYear == currentYear
            case .lastYear:
                return show.releaseYear == currentYear - 1
            case .custom(let searchText):
                return show.title.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    private func sortHistory(_ shows: inout [Show]) {
        switch sortOption {
        case .title:
            return shows.sort { $0.title < $1.title }
        case .year:
            return shows.sort { show1, show2 in
                let year1 = self.getRelevantYear(for: show1)
                let year2 = self.getRelevantYear(for: show2)
                return year1 > year2
            }
        case .dateAdded:
            break
        }
    }
    
    func setSortOption(_ option: SortOption) {
        sortOption = option
        applyFilterAndSort()
    }
    
    func setFilterOption(_ option: FilterOption) {
        filterOption = option
        applyFilterAndSort()
    }
    
    func search(with text: String) {
        if text.isEmpty {
            filterOption = .all
        } else {
            filterOption = .custom(text)
        }
        applyFilterAndSort()
    }
    
    private func getRelevantYear(for show: Show) -> Int {
        if let releaseYear = show.releaseYear {
            return releaseYear
        }
        
        return show.firstAirYear ?? 1970
    }
}
