# FoodAnalyzer

An iOS app that analyzes food using OpenAI's Vision API to provide nutritional information.

## Features

- 📸 Camera integration for food photo capture
- 🤖 AI-powered food analysis using OpenAI Vision
- 📊 Detailed nutritional information
- ✏️ Editable ingredient details
- 📅 History tracking with calendar view

## Requirements

- iOS 15.0+
- Xcode 14.0+
- Swift 5.0+
- OpenAI API Key

## Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/FoodAnalyzer.git
```

2. Open `FoodAnalyzer.xcodeproj` in Xcode

3. Set up the configuration file:
   ```bash
   # Navigate to the project directory
   cd FoodAnalyzer
   
   # Copy the example config file
   cp Config.swift.example Config.swift
   ```

4. Configure your API key:
   - Open the newly created `Config.swift`
   - Replace `YOUR-OPENAI-API-KEY-HERE` with your actual OpenAI API key
   - Never commit your actual API key to version control

5. Build and run the project

## Important Note About Configuration

The `Config.swift` file is intentionally excluded from version control to protect sensitive API keys. Each developer needs to:
1. Copy `Config.swift.example` to `Config.swift`
2. Add their own OpenAI API key
3. Keep their API key private and never commit it

## Architecture

The app follows MVVM (Model-View-ViewModel) architecture:

- **Models**: Data structures for food analysis
- **Views**: SwiftUI views for UI components
- **ViewModels**: Business logic and data processing
- **Services**: API integration and data persistence

## Project Structure

```
FoodAnalyzer/
├── App/
│   └── FoodAnalyzerApp.swift
├── Models/
│   ├── FoodAnalysis.swift
│   └── HistoryEntry.swift
├── Views/
│   ├── ContentView.swift
│   ├── CameraView.swift
│   ├── AnalysisView.swift
│   └── HistoryView.swift
├── ViewModels/
│   └── FoodAnalyzerViewModel.swift
└── Services/
    └── OpenAIService.swift
```

## Usage

1. Launch the app
2. Take a photo of food or choose from library
3. Wait for AI analysis
4. Edit ingredients if needed
5. Save to history
6. View past entries in calendar

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details 