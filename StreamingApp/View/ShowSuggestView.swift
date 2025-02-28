//
//  ShowSuggestView.swift
//  StreamingApp
//
//  Created by iOS Dev Ninja on 28/2/2025.
//

import SwiftUI

enum SwipeDirection {
    case left, right, none
    
    var overlayColor: Color {
        switch self {
        case .left:
            return .blue
        case .right:
            return .red
        default:
            return .clear
        }
    }
}

struct SwipeableCardsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var cardStates: [CardState] = Show.mockShowsFromJsonFile.map { CardState(show: $0)}.shuffled()
    
    @State private var swipeDirection: SwipeDirection = .none
    
    var body: some View {
        NavigationStack {
            ZStack {
                backgroundLayer
                
                // Reverse the array to show first card on top
                if !cardStates.isEmpty {
                    ForEach(cardStates) { cardState in
                        cardLayer(for: cardState)
                    }
                    cardActionButtons
                        .offset(y: -150)
                    
                } else {
                    noMoreCardsView
                }
            }
            .padding()
            .navigationTitle("Discover")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: resetCards) {
                        Image(systemName: "arrow.counterclockwise.circle.fill")
                            .font(.title2)
                            .foregroundStyle(.gray)
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.title2)
                            .foregroundStyle(.gray)
                    }
                }
            }
        }
        .preferredColorScheme(.dark)
        .presentationBackground(.clear)
        .background(.black)
    }
    
    private var backgroundLayer: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Color(.systemGroupedBackground))
            .ignoresSafeArea()
    }
    
    private func cardLayer(for cardState: CardState) -> some View {
        GeometryReader { geometry in
            
            MovieSwipeCard(show: cardState.show, swipeDirection: getDirection(for: cardState))
                .offset(cardState.offset)
                .rotationEffect(.degrees(Double(cardState.offset.width / geometry.size.width) * 20))
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            if let index = cardStates.firstIndex(where: { $0.id == cardState.id }) {
                                cardStates[index].offset = value.translation
                                updateSwipeDirection(for: value.translation)
                            }
                        }
                        .onEnded { value in
                            handleSwipe(cardState: cardState, translation: value.translation, geometry: geometry.size)
                        }
                )
                .animation(.interactiveSpring(), value: cardState.offset)
            
        }
    }
    
    private func getDirection(for cardState: CardState) -> SwipeDirection {
        if cardState.offset.width > 0 {
            return .right
        } else if cardState.offset.width < 0 {
            return .left
        }
        return .none
    }
    
    private func updateSwipeDirection(for translation: CGSize) {
        if translation.width > 0 {
            swipeDirection = .right
        } else if translation.width < 0 {
            swipeDirection = .left
        } else {
            swipeDirection = .none
        }
    }
    
    private func handleSwipe(cardState: CardState, translation: CGSize, geometry: CGSize) {
        let threshold = geometry.width * 0.3
        
        if let index = cardStates.firstIndex(where: { $0.id == cardState.id }) {
            if abs(translation.width) > threshold {
                // if swiping, no add extra animation
                if abs(cardStates[index].offset.width) < geometry.width {
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                        let direction: CGFloat = translation.width > 0 ? 1 : -1
                        cardStates[index].offset.width = direction * geometry.width * 1.5
                    }
                }
                
                // delay remove action
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    if index < cardStates.count {  // 安全檢查
                        cardStates.remove(at: index)
                    }
                }
            } else {
                // reset card position
                withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                    cardStates[index].offset = .zero
                }
            }
        }
        swipeDirection = .none
    }
    
    private func resetCards() {
        cardStates = Show.mockShowsFromJsonFile.map { CardState(show: $0) }.shuffled()
    }
    
    private var noMoreCardsView: some View {
        VStack(spacing: 20) {
            Image(systemName: "heart.circle.fill")
                .font(.system(size: 80))
                .foregroundStyle(.blue)
            
            Text("No More Profiles")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Come back later for more matches!")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            
            Button(action: resetCards) {
                Label("Reset Cards", systemImage: "arrow.counterclockwise")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
            }
            .padding(.top)
        }
        .padding()
    }
    
    private var cardActionButtons: some View {
        GeometryReader { geometry in
            HStack {
                // Skip (Left)
                Button {
                    if let topCard = cardStates.last {
                        withAnimation(.spring(response: 1, dampingFraction: 0.7)) {
                            cardStates[cardStates.count - 1].offset.width = -geometry.size.width * 1.5
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            handleSwipe(cardState: topCard, translation: CGSize(width: -geometry.size.width * 2, height: 0), geometry: geometry.size)
                        }
                    }
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 50)
                            .fill(.gray.opacity(0.5))
                            .frame(width: 100, height: 70)
                            .shadow(radius: 5)
                        
                        Image(systemName: "xmark")
                            .font(.title)
                            .foregroundStyle(.black)
                            .offset(x: 15)
                    }
                }
                .offset(x: -50)
                
                Spacer()
                
                // Like (Right)
                Button {
                    if let topCard = cardStates.last {
                        withAnimation(.spring(response: 1, dampingFraction: 0.7)) {
                            cardStates[cardStates.count - 1].offset.width = geometry.size.width * 1.5
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            handleSwipe(cardState: topCard, translation: CGSize(width: geometry.size.width, height: 0), geometry: geometry.size)
                        }
                    }
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 50)
                            .fill(.red.opacity(0.5))
                            .frame(width: 100, height: 70)
                            .shadow(radius: 5)
                        
                        Image(systemName: "heart.fill")
                            .font(.title)
                            .foregroundStyle(.gray)
                            .offset(x: -15)
                    }
                }
                .offset(x: 50)
            }
            .frame(maxHeight: .infinity)
            .offset(y: geometry.size.height * 0.01)
        }
    }
}

struct MovieSwipeCard: View {
    let show: Show
    let swipeDirection: SwipeDirection
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            // Main Card Content
            VStack(spacing: 0) {
                
                ZStack {
                    AsyncImage(url: URL(string: show.imageSet.verticalPoster.getImageURL(for: 720) ?? "")) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } placeholder: {
                        ProgressView()
                    }
                    .overlay {
                        swipeDirection.overlayColor.opacity(0.3)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 10.0))
                    .padding(.top)

                    // Swipe Indicators
                    SwipeIndicator(direction: swipeDirection)

                }
                .frame(height: 450)
          
                // Card Info
                VStack(alignment: .leading, spacing: 16) {
                    // Name and Age
                    HStack {
                        Text("\(show.title)")
                            .font(.title2.bold())
                            .lineLimit(1)
                        Spacer()
                        RatingView(rating: show.rating)
                    }
                    
                    // Cast
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(show.cast, id: \.self) { interest in
                                CastTag(text: interest)
                            }
                        }
                    }
                    
                    // Bio
                    Text(show.overview)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(minHeight: 200, maxHeight: 300)
                .padding()
            }
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.1), radius: 10)
    }
}

struct CastTag: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.caption)
            .fontWeight(.medium)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color.blue.opacity(0.1))
            .foregroundStyle(.blue)
            .clipShape(Capsule())
    }
}

struct SwipeIndicator: View {
    let direction: SwipeDirection
    
    var body: some View {
        ZStack {
            if direction != .none {
                Group {
                    VStack(spacing: 10) {
                        Image(systemName: direction == .left ? "xmark" : "heart.fill" )
                            .foregroundStyle(direction == .left ? .white : .red)
                        Text(direction == .left ? "SKIP" : "LIKE")
                    }
                }
                .font(.largeTitle.bold())
                .rotationEffect(direction == .left ? .degrees(-15) : .degrees(15))
            }
        }
    }
}

#Preview {
    SwipeableCardsView()
        .preferredColorScheme(.dark)
}
