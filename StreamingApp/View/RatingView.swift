//
//  RatingView.swift
//  StreamingApp
//
//  Created by Gary on 19/2/2025.
//

import SwiftUI

struct RatingView: View {
    let rating: Int
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "star.fill")
                .foregroundColor(.yellow)
            Text("\(rating)%")
        }
    }
}

#Preview {
    RatingView(rating: 50)
}
