# Instagram Stories-like Feature Implementation

## Architectural Overview

This project implements an Instagram Stories-like feature using the MVVM (Model-View-ViewModel) architecture pattern with SwiftUI. The app consists of two main screens:

1. **Stories List Screen**: Displays a horizontal scrollable list of story avatars with indicators for seen/unseen status
2. **Story View Screen**: Fullscreen view for viewing individual stories with like functionality and navigation gestures

### Key Components:

- **Models**: Define the data structures (User, Story, StoryState)
- **ViewModels**: Handle business logic and state management
- **Views**: Display the UI and handle user interactions
- **Services**: Provide data and functionality (Network, Image Loading, State Persistence)

## Design Decisions

### 1. MVVM Architecture
- Clean separation of concerns
- Testable components
- SwiftUI-friendly approach

### 2. Pagination Implementation
- Infinite scrolling using a page-based approach
- When the end of available data is reached, the app cycles through existing data
- Loading indicators for better UX

### 3. State Persistence
- User story states (seen/unseen, liked/unliked) are persisted using UserDefaults
- Each story has its own state, allowing for granular tracking

### 4. Image Loading
- Custom AsyncImage implementation for efficient image loading
- Placeholders during loading for better UX

### 5. Gesture-Based Navigation
- Tap left/right areas to navigate between stories
- Swipe gestures for more intuitive navigation
- Double-tap to like feature

## Assumptions and Limitations

### Assumptions:
- Story content is primarily image-based (could be extended to support videos)
- The app doesn't require user authentication
- Stories are generated on-device rather than fetched from a server
- Story viewing has a fixed duration (5 seconds per story)

### Limitations:
- No backend integration for posting stories
- Limited media types (images only)
- Local state persistence (not synced across devices)
- Basic animation and transitions
- No camera integration for creating stories

## External Libraries
This implementation uses only native iOS frameworks to keep the app lightweight and avoid unnecessary dependencies.

## Future Improvements
- Add support for video stories
- Implement story creation functionality
- Add more interactive elements (polls, questions, etc.)
- Improve animations and transitions
- Implement a more sophisticated data persistence strategy
