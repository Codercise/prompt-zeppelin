# Prompt Zeppelin

A native macOS teleprompter app. Create transcripts, then display them in a floating overlay near your camera so you can read naturally while on video calls or recordings.

## Features

- **Transcript management** - Create, edit, and save transcripts
- **Floating overlay** - Displays near your webcam, stays on top of all windows
- **Word-by-word advancement** - Shows a few words at a time to keep your eyes focused in one spot
- **Adjustable speed** - Control words-per-minute with a slider (60-300 WPM)
- **Play / Pause / Stop** - Full playback control with spacebar shortcut
- **Draggable & resizable** - Position the overlay wherever your camera is
- **Multi-monitor support** - Works across displays

## Requirements

- macOS 14 (Sonoma) or later
- Xcode 16+

## Building

This project uses [XcodeGen](https://github.com/yonaskolb/XcodeGen) to generate the Xcode project.

```bash
brew install xcodegen
xcodegen generate
open PromptZeppelin.xcodeproj
```

Build and run from Xcode, or from the command line:

```bash
xcodebuild -project PromptZeppelin.xcodeproj -scheme PromptZeppelin -configuration Debug build
```

## Usage

1. Launch the app and create a new transcript with the **+** button
2. Give it a title and paste or type your script
3. Click **Open Teleprompter** to show the floating overlay
4. Drag the overlay to position it near your camera
5. Press **Play** (or hit Space) to start scrolling
6. Adjust speed with the WPM slider as needed

## License

[MIT](LICENSE)
