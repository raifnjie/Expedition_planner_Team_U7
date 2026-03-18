# expeditiontravlerteamu7

## Project Summary

The Expedition Planner & Trail Intelligence Hub is an offline-first mobile application designed for students and campus clubs to plan multi-day expeditions, manage gear, track shared budgets, and log trail observations.

## Key Features:
- Expedition Management: Create, edit, and delete expeditions.
- Route Planner: Add multi-stage routes with distance, risk level, and notes.
- Gear Manager: Track equipment loadouts and receive AI-based packing suggestions.
- Trail Logs: Record campsite observations and safety notes offline.
- Budget & Tasks: Manage shared expenses and group task lists.
- Analytics Dashboard: Visualize total distance, gear weight, budget summary, and task completion.
- Settings: Dark mode, measurement preferences, and AI suggestions toggles.

## Offline AI Suggestions:
The app includes a local, rule-based AI engine that provides recommendations based on historical expedition data stored in SQLite. No cloud APIs are used.

# Step-by-Step Setup Instructions

- Clone the Repository using: 
git clone https://github.com/TeamU7/expedition-planner.git
cd expedition-planner

- Install Flutter (if not installed)
Follow instructions at Flutter official site.

- Install Dependencies
flutter pub get
Run the App

- Android Emulator:
flutter run

- Physical Android Device:
Enable developer mode and USB debugging, then run:

flutter run
Build Release APK
flutter build apk --release
APK location: build/app/outputs/flutter-apk/app-release.apk

# Simple User Guide
1. Home Screen
- Displays app logo and initializes the database.
- Automatically transitions to Dashboard.

2. Dashboard
- View all expeditions in a list.
- Tap Create Expedition to start a new expedition.
- Tap an existing expedition card to open Expedition Details.
- Access Settings from the top-right icon.

3. Create / Edit Expedition
- Fill expedition name, start/end dates, notes, and risk level.
- Save to return to Dashboard with the new expedition visible.

4. Expedition Details
- Overview of the expedition with quick access to modules:
- Route Manager: Add/edit stages for your expedition.
- Gear Manager: Track gear weight, categories, and view AI suggestions.
- Trail Logs: Record offline notes and safety observations.
- Budget & Tasks: Add expenses and manage group tasks.
- Analytics: View charts summarizing distance, budget, gear, and tasks.

5. Gear AI Suggestions
- If gear load exceeds historical averages, the app suggests load reduction.
- Users can provide thumbs up/down to improve future suggestions.

6. Settings
- Toggle Dark Mode
- Adjust Measurement Units (metric/imperial)
- Enable/disable AI Suggestions

# Additional Notes
- All data is stored locally using SQLite and SharedPreferences.
- The app works fully offline.
- Analytics and AI suggestions use local historical data only.

Ensure all input fields are valid to avoid errors.
