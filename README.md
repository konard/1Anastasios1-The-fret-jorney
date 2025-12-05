# 🎸 The Fret Journey

> *"Every note is a step, every fret is a direction — welcome to your musical journey."*

An educational mobile app for guitarists that helps them learn the notes on the fretboard in an interactive, gamified way.

Обучающее мобильное приложение для гитаристов, которое помогает выучить ноты на грифе в интерактивной, игровой форме.

---

## 📖 Table of Contents

- [Description](#-description)
- [Features](#-features)
- [Screenshots](#-screenshots)
- [Installation](#-installation)
- [Usage](#-usage)
- [Technical Details](#️-technical-details)
- [Project Structure](#-project-structure)
- [Testing](#-testing)
- [Future Plans](#-future-plans)
- [Contributing](#-contributing)
- [License](#-license)

---

## 🪶 Description

**The Fret Journey** is an educational mobile application for guitarists that helps them learn the notes on the guitar fretboard in an interactive, game-like format. You see a note on the screen, play it on your guitar, and the app listens through the microphone to determine how accurately you hit the correct pitch.

---

## 🎮 Features

- 🎵 **Real-time Note Recognition** — The app listens to your guitar through the microphone and evaluates sound accuracy
- 🎸 **Visual Fretboard with Highlighting** — Correct frets are highlighted with color, errors are shown visually
- 🧠 **Memory and Ear Training** — Helps you learn note positions and develop musical ear
- 🏅 **XP and Leveling System** — Earn points for speed and accuracy, advance to new levels
- 📊 **Statistics and Analysis** — Track your progress and get recommendations on weak areas
- 🔊 **Offline Mode** — Train anywhere, without internet connection

---

## 📱 Screenshots

_Screenshots will be added after the first build_

---

## 🚀 Installation

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (3.0.0 or higher)
- Android Studio or VS Code with Flutter extensions
- Android device or emulator (Android 9+)
- Guitar (acoustic or electric)

### Steps

1. **Clone the repository:**
   ```bash
   git clone https://github.com/1Anastasios1/The-fret-jorney.git
   cd The-fret-jorney
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Configure Android:**
   - Ensure Android SDK is installed
   - Connect your Android device or start an emulator

4. **Run the app:**
   ```bash
   flutter run
   ```

5. **Grant microphone permissions:**
   - When the app starts, grant microphone access permissions

---

## 💡 Usage

### Getting Started

1. **Launch the app** and you'll see the home screen with your current level and statistics

2. **Tap "Start Training"** to begin a practice session

3. **Play the displayed note** on your guitar

4. **Get instant feedback** on accuracy and earn XP

5. **Level up** as you earn more XP and improve your skills

6. **View Statistics** to track your progress and identify weak areas

### Tips for Best Results

- Use the app in a quiet environment for better note recognition
- Tune your guitar before playing
- Play notes clearly and let them ring
- Check your weak areas in Statistics and focus on improving them

---

## ⚙️ Technical Details

### Technologies Used

- **Framework:** Flutter (Dart)
- **Audio Packages:**
  - `flutter_sound` — Audio recording
  - `pitch_detector_dart` — Pitch detection
  - `permission_handler` — Microphone permissions
- **State Management:** Provider
- **Local Storage:** SharedPreferences
- **Cloud Integration (optional):** Firebase
- **Platform:** Android 9+

### Architecture

The app follows a clean architecture pattern with separation of concerns:

- **Models:** Data structures (Note, GameState, UserProgress)
- **Services:** Business logic (AudioService)
- **Screens:** UI components (HomeScreen, GameScreen, StatisticsScreen)
- **Widgets:** Reusable UI components (FretboardWidget)

---

## 📁 Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
│   ├── note.dart            # Note model with frequency calculations
│   ├── game_state.dart      # Game session state
│   └── user_progress.dart   # User progress and XP tracking
├── services/                 # Business logic
│   └── audio_service.dart   # Audio recording and pitch detection
├── screens/                  # App screens
│   ├── home_screen.dart     # Main menu
│   ├── game_screen.dart     # Training session
│   ├── statistics_screen.dart  # Progress statistics
│   └── settings_screen.dart    # App settings
└── widgets/                  # Reusable widgets
    └── fretboard_widget.dart   # Visual fretboard display

test/
├── models/                   # Model tests
│   ├── note_test.dart
│   ├── game_state_test.dart
│   └── user_progress_test.dart
```

---

## 🧪 Testing

### Run Unit Tests

```bash
flutter test
```

### Run Integration Tests

```bash
flutter test integration_test
```

### Test Coverage

The project includes comprehensive unit tests for:
- Note model and frequency calculations
- Game state management
- User progress and XP system
- Statistics calculations

---

## 🌱 Future Plans

- 🎧 Electric guitar connection via USB or audio interface
- ☁️ Cloud synchronization and result storage
- 🧩 Custom training sessions and levels
- 🫶 **"Teacher-Student"** mode for music teachers and schools
- 🌐 iOS support
- 🎯 Custom difficulty levels
- 🏆 Global leaderboards
- 🎼 Music theory lessons integration

---

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📜 License

This project is distributed under the **MIT License**.
You can freely use, modify, and distribute the code,
with attribution to the original repository.

See [LICENSE](LICENSE) for more information.

---

## 🧑‍🎤 Authors

Project created with love for music, guitar, and the idea that every note is a step forward, and every fret is a new point of growth.

> **The Fret Journey** — not just training, but a musician's path to conscious sound.

---

## 💬 Brief Description

**Learn guitar notes with real-time sound recognition and gamified memory training.**
_An interactive journey across the fretboard._

---

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Open source audio processing libraries
- Guitar teachers and students who inspired this project

---

**Made with ❤️ for guitarists**
