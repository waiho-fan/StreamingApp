//
//  HistoryView.swift
//  StreamingApp
//
//  Created by iOS Dev Ninja on 21/2/2025.
//

import SwiftUI

struct HistoryView: View {    
    @EnvironmentObject private var viewModel: HistoryViewModel
    @State private var showingAlert: Bool = false
    @Environment(\.editMode) private var editMode

    var body: some View {
        NavigationStack {
            if viewModel.watchHistory.isEmpty {
                VStack {
                    Text("No Watch History Found")
                        .font(.title)
                        .foregroundStyle(.secondary)
                }
            } else {
                VStack {
                    // Category Selection
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 60) {
                            ForEach(HistoryViewModel.SortOption.allCases, id: \.self) { option in
                                VStack {
                                    Text(option.stringValue)
                                        .foregroundColor(viewModel.sortOption == option ? .red : .white)
                                        .fontWeight(viewModel.sortOption == option ? .bold : .regular)
                                    
                                    if viewModel.sortOption == option {
                                        Rectangle()
                                            .frame(height: 2)
                                            .foregroundColor(.red)
                                    }
                                }
                                .onTapGesture {
                                    withAnimation {
                                        viewModel.sortOption = option
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 30)
                    
                    List {
                        ForEach(viewModel.filteredHistory) { show in
                            if editMode?.wrappedValue.isEditing == true {
                                HistoryRow(show: show)
                            } else {
                                NavigationLink {
                                    ShowDetailView(show: show)
                                } label: {
                                    HistoryRow(show: show)
                                }
                            }
                        }
                        .onDelete { indexSet in
                            viewModel.deleteShows(at: indexSet)
                        }
                        .onMove { (source, destination) in
                            viewModel.watchHistory.move(fromOffsets: source, toOffset: destination)
                            viewModel.saveHistory()
                        }
                    }
                    .listRowSpacing(10)
                    .listStyle(.plain)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button {
                                showingAlert = true
                            } label: {
                                Image(systemName: "trash")
                            }
                            .disabled(viewModel.watchHistory.isEmpty)
                        }
                        ToolbarItem(placement: .navigationBarLeading) {
                            EditButton()
                                .disabled(viewModel.watchHistory.isEmpty)
                        }
                    }
                    .foregroundStyle(.primary)
                    .alert("Clear History", isPresented: $showingAlert) {
                        Button("Cancel", role: .cancel) {}
                        Button("Clear", role: .destructive) {
                            viewModel.clearHistory()
                        }
                    } message: {
                        Text("Are you sure you want to clear your watch history?")
                    }
                }
            }
        }
        .preferredColorScheme(.dark)
        .background(.black)
        .searchable(text: $viewModel.searchText) {
            if viewModel.searchText.isEmpty {
                Text("No results found")
            }
        }
        .onAppear {
            viewModel.loadHistory()
        }
        .onChange(of: viewModel.searchText) { _ , newValue in
            viewModel.search(with: newValue)
        }
    }
}

struct HistoryRow: View {
    @EnvironmentObject private var viewModel: HistoryViewModel
    @StateObject private var rowViewModel: HistoryRowViewModel

    init(show: Show) {
        _rowViewModel = StateObject(wrappedValue: HistoryRowViewModel(show: show))
    }
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: rowViewModel.show.imageSet.horizontalPoster.getImageURL(for: 720) ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 120)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            } placeholder: {
                ProgressView()
                    .frame(width: 120)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(rowViewModel.show.title)
                    .font(.headline)
                Text(rowViewModel.formattedYear)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .swipeActions(edge: .trailing) {
            Button(role:. destructive) {
                withAnimation {
                    viewModel.deleteShow(rowViewModel.show)
                }
            } label: {
                Label("Remove", systemImage: "trash")
            }
        }
    }
}

#Preview {
    HistoryView()
        .environmentObject(HistoryViewModel())
        .preferredColorScheme(.dark)
}
