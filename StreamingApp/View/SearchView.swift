//
//  SearchView.swift
//  StreamingApp
//
//  Created by Gary on 21/2/2025.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    @State private var searchText = ""
    @State private var selectedCategory: ShowCategory = .movies
    
//    let shows: [Show] = Array(repeating: Show.mock, count: 10)
//    let shows: [Show] = []

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
                    ForEach(ShowCategory.allCases, id: \.self) { category in
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
                    ForEach(0..<viewModel.shows.count, id: \.self) { index in
                        MovieCard(searchViewModel: viewModel, show: viewModel.shows[index])
                    }
                }
                .padding(.horizontal)
            }
        }
        .background(Color.black)
        .foregroundColor(.white)
        .onAppear {
            viewModel.loadMockData()
        }
        .task {
//            viewModel.loadShowData()
        }
    }
}

// MovieCard
struct MovieCard: View {
    @StateObject private var viewModel: MovieCardViewModel

    init(searchViewModel: SearchViewModel, show: Show) {
        _viewModel = StateObject(
            wrappedValue: MovieCardViewModel(
                searchViewModel: searchViewModel,
                show: show
            )
        )
    }

    var body: some View {
        VStack(alignment: .leading) {
            // Image
            AsyncImage(url: URL(string: viewModel.posterURL ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            } placeholder: {
                ProgressView()
            }
            .frame(height: 200)
            
            // Info
            VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.show.title)
                    .font(.headline)
                Text("\(viewModel.formattedYear)")
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
