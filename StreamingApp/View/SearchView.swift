//
//  SearchView.swift
//  StreamingApp
//
//  Created by Gary on 21/2/2025.
//

import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    @State private var selectedCategory: Category = .movies
    
    // Category
    enum Category: String, CaseIterable {
        case movies = "Movies"
        case tvSeries = "Tv Series"
        case documentary = "Documentary"
        case sports = "Sports"
    }
    
    let shows: [Show] = Array(repeating: Show.mock, count: 10)

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Title
            VStack(alignment: .leading, spacing: 8) {
                Text("Find Movies, Tv series,\nand more..")
                    .font(.title)
                    .fontWeight(.bold)
            }
            .padding(.horizontal)
            
            // Search bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("Sherlock Holmes", text: $searchText)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(15)
            .padding(.horizontal)
            
            // Category Selection
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 24) {
                    ForEach(Category.allCases, id: \.self) { category in
                        VStack {
                            Text(category.rawValue)
                                .foregroundColor(selectedCategory == category ? .red : .white)
                            
                            if selectedCategory == category {
                                Rectangle()
                                    .frame(height: 2)
                                    .foregroundColor(.red)
                            }
                        }
                        .onTapGesture {
                            withAnimation {
                                selectedCategory = category
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            
            // Move Grid
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: 16),
                    GridItem(.flexible(), spacing: 16)
                ], spacing: 16) {
                    ForEach(0..<shows.count, id: \.self) { index in
                        MovieCard(show: shows[index])
                    }
                }
                .padding(.horizontal)
            }
        }
        .background(Color.black)
        .foregroundColor(.white)
    }
}

// MovieCard
struct MovieCard: View {
    let show: Show
    
    var body: some View {
        VStack(alignment: .leading) {
            // Image
            Image("image-vertical-mock")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            
            // Info
            VStack(alignment: .leading, spacing: 4) {
                Text(show.title)
                    .font(.headline)
                Text("\(show.releaseYear)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding(.vertical, 8)
        }
    }
}

#Preview {
    SearchView()
}
