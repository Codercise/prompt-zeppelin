# Architecture

## App Structure

Prompt Zeppelin is a standard macOS SwiftUI app with one special component: a floating overlay window for the teleprompter display.

### Main Window
The main window is the transcript manager where users create, edit, and select transcripts. It uses a sidebar/detail layout:
- **Sidebar**: List of saved transcripts
- **Detail**: Text editor for the selected transcript + playback controls

### Teleprompter Overlay
A separate `NSPanel`-based window that:
- Appears at the top of the primary screen (near the webcam)
- Is borderless and semi-transparent
- Floats above all other windows
- Does not appear in Mission Control or the Dock
- Shows the current portion of the transcript in large, readable text

### Data Flow
```
TranscriptStore (disk) <-> TranscriptListViewModel <-> ContentView
                                                          |
                                                    TeleprompterViewModel <-> TeleprompterOverlayView (NSPanel)
```

## Persistence
Transcripts are saved as individual JSON files in:
```
~/Library/Application Support/PromptZeppelin/transcripts/
```

Each file is named by the transcript's UUID. The `TranscriptStore` handles serialization via `Codable`.
