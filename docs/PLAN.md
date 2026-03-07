# Prompt Zeppelin - Development Plan

## Core Features

### 1. Transcript Management
- Create new transcripts (title + body text)
- Edit existing transcripts
- Delete transcripts
- List saved transcripts
- Persist transcripts as JSON in Application Support

### 2. Teleprompter Overlay
- Floating window (NSPanel) that sits at the top of the screen near the webcam
- Semi-transparent background so it doesn't fully block content underneath
- Large, readable text (customizable font size)
- Shows a few words/lines at a time, scrolling through the transcript
- Stays on top of all other windows
- Click-through when not being interacted with

### 3. Playback Controls
- Play / Pause / Stop
- Adjustable speed (words per minute)
- Keyboard shortcuts for play/pause (e.g., Space or a global hotkey)
- Visual progress indicator

### 4. Settings
- Font size for teleprompter text
- Scroll speed (WPM)
- Overlay opacity/background color
- Which monitor/position to display on

## Architecture

### Models
- `Transcript`: id, title, body, createdAt, updatedAt

### Views
- `ContentView`: Main window with transcript list and editor
- `TeleprompterOverlayView`: The floating overlay that displays scrolling text
- `SettingsView`: App preferences

### ViewModels
- `TranscriptListViewModel`: Manages the list of transcripts, CRUD operations
- `TeleprompterViewModel`: Controls playback state, speed, current word position

### Services
- `TranscriptStore`: Handles loading/saving transcripts to disk

## Implementation Phases

### Phase 1 - Foundation
- Set up Xcode project structure
- Transcript model and persistence
- Basic main window with transcript list and text editor
- Create, edit, delete, save transcripts

### Phase 2 - Teleprompter Overlay
- Floating NSPanel overlay window
- Display transcript text with word-by-word or line-by-line scrolling
- Play/pause/stop controls
- Speed adjustment

### Phase 3 - Polish
- Keyboard shortcuts
- Settings/preferences
- Visual polish (animations, transitions)
- Menu bar integration

## Technical Considerations

- Use `NSPanel` with `styleMask: .nonactivatingPanel` for the overlay so it floats without stealing focus
- Use `NSWindow.Level.floating` or `.screenSaver` to keep it on top
- Timer-based word advancement for teleprompter scrolling
- Store transcripts in `~/Library/Application Support/PromptZeppelin/`
