//
//  HistoryViewModel.swift
//  StreamingApp
//
//  Created by Gary on 24/2/2025.
//

import Foundation

class HistoryViewModel: ObservableObject {
    @Published var watchHistory: [Show] = []
    private let userDefaults = UserDefaults.standard
    private let historyKey = "WatchHistory"
    @Published var isEditing: Bool = false
    
    @Published var filteredHistory: [Show] = []
    @Published var sortOption: SortOption = .title
    @Published var filterOption: FilterOption = .all
    
    init() {
        loadHistory()
    }
    
    enum SortOption {
        case title
        case year
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
        watchHistory.removeAll { $0.id == show.id }
        saveHistory()
    }
    
    func deleteShows(at offsets: IndexSet) {
        watchHistory.remove(atOffsets: offsets)
        saveHistory()
    }
    
    //MARK: - Private
    private func loadHistory() {
        print("Loading history...")
//        watchHistory = Show.mockShowsFromJsonFile
        
        if let savedData = userDefaults.data(forKey: historyKey) {
            if let history = try? JSONDecoder().decode([Show].self, from: savedData) {
                watchHistory = history
                filteredHistory = watchHistory
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
            return shows.sort { $0.releaseYear ?? 1970 > $1.releaseYear ?? 1970 }
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
}
