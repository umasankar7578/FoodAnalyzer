# FoodAnalyzer - Product Requirements Document

## Overview
FoodAnalyzer is an iOS application that uses AI to analyze food images and provide nutritional information. The app allows users to capture or select food images, get AI-powered analysis, edit the results, and maintain a history of their food intake.

## Features

### 1. Camera Integration
- Camera capture interface
- Photo library access
- Image preview and retake option
- Support for both device and simulator testing

### 2. AI Analysis
- Integration with OpenAI Vision API
- Food recognition
- Nutritional information extraction
- JSON response parsing

### 3. Editable Results
- Display analyzed ingredients
- Editable fields for:
  - Food name
  - Calories
  - Protein
  - Carbohydrates
  - Fat
- Real-time calorie updates

### 4. History Tracking
- Calendar view
- Daily food log
- Nutritional summaries
- Data persistence

## Technical Specifications

### API Integration

#### OpenAI Vision API
```swift
Endpoint: https://api.openai.com/v1/chat/completions
Method: POST
Headers:
  - Authorization: Bearer {API_KEY}
  - Content-Type: application/json
Body:
{
  "model": "gpt-4-vision-preview",
  "messages": [
    {
      "role": "user",
      "content": [
        {
          "type": "text",
          "text": "Analyze this food image..."
        },
        {
          "type": "image_url",
          "image_url": {
            "url": "data:image/jpeg;base64,{IMAGE_DATA}"
          }
        }
      ]
    }
  ],
  "max_tokens": 1000
}
```

### Data Models

#### FoodAnalysis
```swift
struct FoodAnalysis: Codable {
    var id: UUID
    var foodName: String
    var calories: Int
    var protein: String
    var carbs: String
    var fat: String
    var ingredients: [String]
    var timestamp: Date
}
```

#### HistoryEntry
```swift
struct HistoryEntry: Codable {
    var id: UUID
    var date: Date
    var entries: [FoodAnalysis]
    var totalCalories: Int
}
```

## User Flow

1. Launch App
   - Display camera/photo options
   - Show history calendar

2. Capture Food
   - Take photo or select from library
   - Preview and confirm

3. Analysis
   - Send to OpenAI
   - Display loading indicator
   - Show results

4. Edit Results
   - Modify ingredients/nutrition
   - Update calculations

5. Save Entry
   - Add to history
   - Update calendar

## Storage

- Use CoreData for persistent storage
- Daily backup to UserDefaults
- Export functionality (optional)

## Testing

- Unit tests for ViewModels
- UI tests for critical paths
- Network mocking for API tests

## Future Enhancements

1. Meal planning
2. Nutritional goals
3. Recipe suggestions
4. Social sharing
5. Multiple food items per image 