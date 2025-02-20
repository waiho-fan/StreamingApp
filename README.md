# StreamingApp

A modern iOS streaming content browser built with SwiftUI, demonstrating clean MVVM architecture and best practices in iOS development.

## Overview

StreamingApp is a showcase application that implements core features of a streaming platform's browsing experience. Built with SwiftUI and following the MVVM (Model-View-ViewModel) architectural pattern, it demonstrates how to create a maintainable and scalable iOS application while incorporating modern iOS development practices.

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
- **Services**: Handling API communication and data persistence
- **Repositories**: Abstracting data sources and business logic

## Getting Started

1. Clone the repository
2. Open StreamingApp.xcodeproj in Xcode
3. Build and run the project

## Requirements

- iOS 16.0+
- Xcode 14.0+
- Swift 5.5+

## Future Enhancements

- Search functionality
- Content filtering
- Offline support
- Watchlist management
- Playback integration
