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

3. Configure your API key:
   - Open `Config.swift`
   - Replace `YOUR_API_KEY_HERE` with your OpenAI API key
   - Never commit your actual API key to version control

4. Build and run the project

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