# Custom Header Timer TabView 📱⏱️

- Custom Header Timer TabView is an iOS SwiftUI project that demonstrates a dynamic header section with an auto-scrolling TabView, gesture interactions, and animated UI components.
- The header automatically switches between tabs every 5 seconds, while also allowing users to manually control tab navigation. The project also includes additional UI features like a custom top reloader animation and a responsive announcement container.

- This project focuses on creating interactive UI behavior, combining timers, gestures, animations, and scroll-based state control to build a smooth and responsive user experience.

## ✨ Features
### ⏱️ Auto-Switching TabView

- Header TabView automatically switches tabs every 5 seconds.

- Built using SwiftUI TabView with timer-based state updates.

### 🖐 Manual Tab Switching

- Users can manually change tabs using gestures.

- When a tab is changed manually, the timer resets to 0 so the selected tab stays visible for the full 5 seconds.

### 📜 Scroll-Aware Timer Control

- When the user scrolls down the screen, the timer pauses.

- When the user returns to the top, the same tab remains visible and the timer resumes.

### 🔄 Animated Top Reloader

- A custom reloader animation appears from the top edge of the screen.

- The loader:

  - Slides down from the top

  - Rotates for a specific duration

  - Animates back to the top and disappears

### 📢 Announcement Container

- Tapping the Announcement button opens a custom announcement interface.

- Device-specific behavior:

  - iPhone: Opens a custom sliding container

  - iPad: Displays announcements using a Popover

- This ensures the UI follows Apple's platform design patterns for different devices.

# 🛠 Tech Stack

## Language

- Swift

## Frameworks

- SwiftUI

- Foundation

## Concepts Used

- Timer-based UI updates

- Gesture handling

- Scroll position tracking

- Custom animations

- Conditional UI for iPhone and iPad

- State management in SwiftUI

# 📷 Demo

<img src="Dynamic_Header/gif1.gif" width="300"/>
