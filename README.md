# BreathFlow

A minimalist iOS breathwork application built with SwiftUI. Guide your breathing with animated visuals, audio cues, and haptic feedback to help reduce stress, improve focus, and promote relaxation.

## Features

### Breathing Exercises
- **Balanced (5-5)**: Equal inhale and exhale for focus and calm
- **Relaxing (4-8)**: Extended exhale for deep relaxation
- **Session Durations**: 5, 10, 15, or 20 minutes

### Visual & Audio Guidance
- Animated ring that fills during inhale and empties during exhale
- Soft audio tones on breath phase transitions with volume control
- Haptic feedback with adjustable intensity (light, medium, strong)

### Live Activities
- Track your session from the Lock Screen and Dynamic Island
- See current breath phase, progress bar, and breaths remaining
- Breathing bar animates with inhale/exhale phases

### Session History
- View all completed sessions grouped by date
- Track exercise type, duration, breath count, and time
- Swipe to delete individual sessions

### Daily Reminders
- Configurable reminder time
- Smart reminder option: only notifies if you haven't practiced that day
- Helps maintain your breathing practice streak

### Health Integration
- Sync completed sessions to Apple Health as Mindful Minutes
- Optional integration via Settings

### Progress Tracking
- Total breathing time tracked
- Daily streak for consecutive practice days

### Background Support
- Continue sessions with the app in background
- Audio cues continue playing

## Requirements

- iOS 16.2+
- Xcode 15+

## Building

This project uses [XcodeGen](https://github.com/yonaskolb/XcodeGen) to generate the Xcode project.

```bash
# Install XcodeGen if needed
brew install xcodegen

# Generate the Xcode project
cd BreathFlow
xcodegen generate

# Open in Xcode
open BreathFlow.xcodeproj
```

## Project Structure

```
BreathFlow/
├── BreathFlowApp.swift              # App entry point
├── Models/
│   ├── BreathingExercise.swift      # Exercise types & durations
│   ├── UserStats.swift              # Stats model
│   ├── SessionRecord.swift          # Session history record
│   └── ReminderSettings.swift       # Reminder configuration
├── Views/
│   ├── HomeView.swift               # Main screen with stats
│   ├── ExercisePickerView.swift     # Exercise selection
│   ├── BreathingSessionView.swift   # Active breathing session
│   ├── CompletionView.swift         # Session complete screen
│   ├── SettingsView.swift           # Settings & preferences
│   └── SessionHistoryView.swift     # Past sessions list
├── Components/
│   ├── BreathingCircle.swift        # Animated breathing ring
│   └── StatCard.swift               # Stats display card
├── Services/
│   ├── StatsManager.swift           # Persist stats to UserDefaults
│   ├── AudioManager.swift           # Audio playback
│   ├── HapticManager.swift          # Haptic feedback
│   ├── HealthKitManager.swift       # Apple Health integration
│   ├── LiveActivityManager.swift    # Live Activities management
│   ├── SessionHistoryManager.swift  # Session history persistence
│   └── NotificationManager.swift    # Daily reminder notifications
├── Utilities/
│   └── AppDelegate.swift            # Notification handling
├── Extensions/
│   ├── Color+Theme.swift            # App color theme
│   └── Double+Extensions.swift      # Helper extensions
└── Resources/
    ├── inhale.mp3                   # Inhale sound
    ├── exhale.mp3                   # Exhale sound
    └── complete.mp3                 # Session complete sound

Shared/
└── BreathingActivityAttributes.swift # Live Activity data model

BreathFlowLiveActivity/
├── BreathFlowLiveActivity.swift     # Live Activity UI
└── BreathFlowLiveActivityBundle.swift
```

## How It Works

1. Select a breathing exercise (Balanced or Relaxing)
2. Choose your session duration
3. A 3-second countdown prepares you
4. Follow the animated ring: expand on inhale, contract on exhale
5. Audio cues and haptic feedback guide each phase transition
6. Track your session from the Lock Screen via Live Activities
7. View your progress with streaks, total time, and session history

## Tech Stack

- **SwiftUI** for UI
- **AVFoundation** for audio playback
- **ActivityKit** for Live Activities
- **HealthKit** for Mindful Minutes sync
- **UserNotifications** for daily reminders
- **Core Haptics** for haptic feedback
- **UserDefaults** for local persistence

## License

MIT
