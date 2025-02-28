//
//  CardState.swift
//  StreamingApp
//
//  Created by Gary on 28/2/2025.
//

import Foundation

struct CardState: Identifiable {
    let id: String
    let show: Show
    var offset: CGSize
    
    init(show: Show) {
        self.id = show.id
        self.show = show
        self.offset = .zero
    }
}
