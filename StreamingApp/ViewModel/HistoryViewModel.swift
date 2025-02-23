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
    
    init() {
        loadHistory()
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
            }
        }
    }
    
    func saveHistory() {
        if let savedData = try? JSONEncoder().encode(watchHistory) {
            userDefaults.set(savedData, forKey: historyKey)
        }
    }
}
