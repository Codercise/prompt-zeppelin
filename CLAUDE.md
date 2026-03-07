# Prompt Zeppelin

A native macOS teleprompter app built with Swift and SwiftUI.

## Project Overview

Prompt Zeppelin displays scrolling transcript text in a floating overlay near the top of the screen (close to the webcam) so users can read scripts naturally while on camera. Users can create, save, and manage transcripts, control playback speed, and pause/resume.

## Tech Stack

- **Language:** Swift
- **UI Framework:** SwiftUI
- **Target:** macOS 14+ (Sonoma)
- **Build System:** Xcode / Swift Package Manager
- **Architecture:** MVVM

## Key Principles

- Use native macOS APIs exclusively (no Electron, no web views)
- Keep the app lightweight and focused
- The teleprompter overlay should be minimal, non-intrusive, and positioned near the camera
- Prioritize readability and simplicity in both code and UI

## Project Structure

```
PromptZeppelin/
  PromptZeppelinApp.swift    # App entry point
  Models/                    # Data models (Transcript, etc.)
  Views/                     # SwiftUI views
  ViewModels/                # View models
  Services/                  # File persistence, etc.
docs/                        # Documentation and plans
```

## Development Notes

- The floating teleprompter window uses NSPanel with `.nonactivatingPanel` style so it stays on top without stealing focus
- Transcripts are stored as JSON files in the app's Application Support directory
- Speed control is words-per-minute based
