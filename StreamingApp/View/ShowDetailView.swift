//
//  ShowDetailView.swift
//  StreamingApp
//
//  Created by Gary on 19/2/2025.
//

import SwiftUI

struct ShowDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) var dismiss
    
    @StateObject var viewModel: ShowDetailViewModel
    
    init(show: Show) {
        _viewModel = StateObject(wrappedValue: ShowDetailViewModel(show: show))
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Image
                    AsyncImage(url: URL(string: viewModel.getPosterURL() ?? "")) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(RoundedRectangle(cornerRadius: 20.0))
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(maxWidth: .infinity)
                    
                    // Title, Rating
                    HStack {
                        Text(viewModel.show.title)
                            .font(.title)
                        Spacer()
                        RatingView(rating: viewModel.show.rating)
                    }
                    
                    // Year • Episode
                    Text("\(viewModel.formattedYear) • \(viewModel.show.episodeCount ?? 0) Episodes")
                        .foregroundColor(.secondary)
                    
                    // Genres
                    Text(viewModel.formattedGenres)
                        .font(.subheadline)
                    
                    // Overview
                    Text(viewModel.show.overview)
                        .padding(.top)
                    
                    // Cast
                    CastSection(cast: viewModel.show.cast)
                }
                .padding()
            }
            .navigationTitle(viewModel.show.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.gray)
                    }
                }
            }
            .background(.black)
            .foregroundStyle(.white)
        }
        .preferredColorScheme(.dark)
        .presentationBackground(.clear)
        .background(.black)
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    ShowDetailView(show: Show.mock)
}
