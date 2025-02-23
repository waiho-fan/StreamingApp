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
                TextField("Sherlock Holmes", text: $viewModel.searchText)
                    .foregroundStyle(.black)
                    
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
                                .foregroundColor(viewModel.selectedCategory == category ? .red : .white)
                            
                            if viewModel.selectedCategory == category {
                                Rectangle()
                                    .frame(height: 2)
                                    .foregroundColor(.red)
                            }
                        }
                        .onTapGesture {
                            withAnimation {
                                viewModel.selectedCategory = category
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
                    ForEach(viewModel.shows) { show in
                        MovieCard(searchViewModel: viewModel, show: show)
                    }
                }
                .padding(.horizontal)
            }
        }
        .background(Color.black)
        .foregroundColor(.white)
//        .onChange(of: viewModel.selectedCategory) { oldValue, newValue in
//            print(">>> selectedCategory: \(oldValue) -> \(newValue) ")
//        }
        .task {
            viewModel.loadMockData()
//            await viewModel.loadShowDataForFilter()
        }
    }
}

// MovieCard
struct MovieCard: View {
    @StateObject private var viewModel: MovieCardViewModel
    @State private var showingDetail: Bool = false

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
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .frame(height: 50)
                Text("\(viewModel.formattedYear)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 8)
        }
        .frame(width: UIScreen.main.bounds.width / 2 - 24)
        .onTapGesture {
            showingDetail = true
        }
        .sheet(isPresented: $showingDetail) {
            ShowDetailView(show: viewModel.show)
                .presentationDragIndicator(.visible)
                .presentationBackground(.clear)
        }
    }
}

#Preview {
    SearchView()
        .environmentObject(HistoryViewModel())
}
