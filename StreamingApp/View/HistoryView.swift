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
    @State private var searchText: String = ""

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
                    Picker("Sort By", selection: $viewModel.sortOption) {
                        Text("Title").tag(HistoryViewModel.SortOption.title)
                        Text("Year").tag(HistoryViewModel.SortOption.year)
                    }
                    .pickerStyle(.segmented)
                    .padding()
                    .onChange(of: viewModel.sortOption) {
                        viewModel.applyFilterAndSort()
                    }
                    
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
        .searchable(text: $searchText) {
            if searchText.isEmpty {
                Text("No results found")
            }
        }
        .onChange(of: searchText) { _ , newValue in
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
