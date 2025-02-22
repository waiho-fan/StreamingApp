//
//  CastSection.swift
//  StreamingApp
//
//  Created by Gary on 19/2/2025.
//

import SwiftUI

struct CastSection: View {
    let cast: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Cast")
                .font(.headline)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(cast, id: \.self) { actor in
                        Text(actor)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.secondary.opacity(0.3))
                            .cornerRadius(8)
                    }
                }
            }
        }
    }
}

#Preview {
    CastSection(cast: ["Cast1", "Cast2", "Cast3", "Cast4", "Cast5"])
        .preferredColorScheme(.dark)

}
