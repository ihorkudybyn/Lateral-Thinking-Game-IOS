# Lateral Thinking Game

A SwiftUI-based iOS application that challenges users with lateral thinking puzzles. Players solve mysteries by asking yes/no questions in an interactive chat interface.

## How It Works

The "Lateral Thinking Game" challenges users to solve puzzles through lateral thinking. Players uncover the story behind each puzzle by asking a series of yes/no questions. The app analyzes questions and provides answers, gradually guiding players toward key clues needed to solve the puzzle.

## Technical Details

### Architecture
- Built with SwiftUI
- Follows MVVM architecture pattern
- Uses UserDefaults for local session storage

### Key Components
- **Views**: HomeView, PlayView, GameView with supporting UI components
- **ViewModel**: GameViewModel manages game state and API communication
- **Models**: Story, Chat, Message, and Session data structures
- **Network Layer**: Communicates with backend server for puzzle data and conversation(the setup of backend server is not available for that moment)

## Setup & Development

### Requirements
- iOS 18.0+
- Xcode 16.0+
- Swift 5.0+

### Installation
1. Clone the repository
2. Open `Lateral Thinking Game.xcodeproj` in Xcode
3. Configure the backend server URL in GameViewModel.swift and PlayView.swift
4. Build and run the application

### Backend Server
The app requires a backend server running on `http://localhost:8001` (default development URL). The server should provide:
- Story listings (`/stories/`)
- Conversation management (`/conversation/get_chat_by_session/`, `/conversation/send_user_message`, etc.)

## Usage

1. Start the app and browse available puzzles
2. Select a puzzle to begin
3. Ask yes/no questions to gather information
4. Use the hint button if you get stuck
5. Try to solve the mystery based on the information you receive
   
