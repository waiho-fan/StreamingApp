# StreamingApp

A modern iOS streaming content browser built with SwiftUI, demonstrating clean MVVM architecture and best practices in iOS development.

## Overview

StreamingApp is a showcase application that implements core features of a streaming platform's browsing experience. Built with SwiftUI and following the MVVM architectural pattern, it demonstrates how to create a maintainable and scalable iOS application while incorporating modern iOS development practices.

## Screenshot

<img src="/StreamingApp/Screenshot/demo.gif" width="300" alt="Demo" />
<div align="left">
  <p float="left">
    <img src="/StreamingApp/Screenshot/trending.png" width="300" alt="Trending.png" />
    <img src="/StreamingApp/Screenshot/show-detail.png" width="300" alt="Show Detail" />
    <img src="/StreamingApp/Screenshot/search.png" width="300" alt="Search" />
    <img src="/StreamingApp/Screenshot/search-filter.png" width="300" alt="Search Filter" />
    <img src="/StreamingApp/Screenshot/history.png" width="300" alt="History" />
    <img src="/StreamingApp/Screenshot/history-search.png" width="300" alt="History Search" />
  </p>
</div>

## Key Features

- Browse streaming content with smooth horizontal scrolling and 3D card animations
- View detailed information about shows including seasons and episodes
- Clean MVVM architecture with clear separation of concerns
- Efficient API integration with async/await
- Responsive UI with loading states and error handling
- Image caching and lazy loading for optimal performance

## Technical Stack

- SwiftUI for UI implementation
- Combine framework for reactive programming
- Swift Concurrency (async/await) for network calls
- URLSession for API integration
- Native image caching and loading

## Architecture

The application follows MVVM architecture with these key components:

- **Views**: SwiftUI views handling the UI presentation
- **ViewModels**: Managing UI logic and data transformation
- **Models**: Core data structures representing content
- **ApiClient**: Handling API communication and data persistence

## Getting Started

1. Clone the repository
2. Open StreamingApp.xcodeproj in Xcode
3. Build and run the project

## Requirements

- iOS 16.0+
- Xcode 14.0+
- Swift 5.5+

## Future Enhancements

- Offline support
- Playback integration
- Video Play
- Account management
