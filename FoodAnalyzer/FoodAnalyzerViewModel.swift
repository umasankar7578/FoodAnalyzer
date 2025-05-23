import Foundation
import UIKit
import SwiftUI

@MainActor
class FoodAnalyzerViewModel: ObservableObject {
    @Published var selectedImage: UIImage?
    @Published var currentAnalysis: FoodAnalysis?
    @Published var isAnalyzing = false
    @Published var errorMessage: String?
    @Published var historyEntries: [HistoryEntry] = [] {
        didSet {
            saveHistory() // Auto-save whenever entries change
        }
    }
    
    private let openAIService: OpenAIService
    
    init() {
        self.openAIService = OpenAIService(apiKey: Config.openAIAPIKey)
        loadHistory()
    }
    
    func analyzeImage() async {
        guard let image = selectedImage else {
            errorMessage = "No image selected"
            return
        }
        
        isAnalyzing = true
        errorMessage = nil  // Clear any previous errors
        
        do {
            print("Starting image analysis...")
            let analysisText = try await openAIService.analyzeFood(image: image)
            print("Analysis completed: \(analysisText)")
            
            // Parse the analysis text to create a FoodAnalysis object
            currentAnalysis = parseAnalysis(analysisText)
            
        } catch let error as OpenAIError {
            switch error {
            case .imageConversionFailed:
                errorMessage = "Failed to process the image. Please try another photo."
            case .invalidResponse:
                errorMessage = "Received an invalid response from the server. Please try again."
            case .apiError(let message):
                errorMessage = "API Error: \(message)"
            }
            print("Error during analysis: \(errorMessage ?? "Unknown error")")
        } catch {
            errorMessage = "An unexpected error occurred: \(error.localizedDescription)"
            print("Unexpected error: \(error)")
        }
        isAnalyzing = false
    }
    
    func saveAnalysis() {
        guard let analysis = currentAnalysis else { return }
        
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        print("Saving analysis for: \(analysis.foodName) with calories: \(analysis.calories)")
        
        if let entryIndex = historyEntries.firstIndex(where: { calendar.isDate($0.date, inSameDayAs: today) }) {
            // Create a new entry with the updated values
            var updatedEntry = historyEntries[entryIndex]
            updatedEntry.addEntry(analysis)
            historyEntries[entryIndex] = updatedEntry
            print("Updated existing entry. Total entries for today: \(updatedEntry.entries.count)")
        } else {
            // Create a new entry for today
            let newEntry = HistoryEntry(date: today, entries: [analysis])
            historyEntries.append(newEntry)
            print("Created new entry for today")
        }
        
        // Sort entries by date (most recent first)
        historyEntries.sort { $0.date > $1.date }
        
        clearAnalysis()
    }
    
    func clearAnalysis() {
        selectedImage = nil
        currentAnalysis = nil
        errorMessage = nil
    }
    
    private func parseAnalysis(_ text: String) -> FoodAnalysis {
        var foodName = "Unknown Food"
        var calories = 0
        var protein = "0g"
        var carbs = "0g"
        var fat = "0g"
        var ingredients: [String] = []
        
        
        return FoodAnalysis(
            foodName: foodName,
            calories: calories,
            protein: protein,
            carbs: carbs,
            fat: fat,
            ingredients: ingredients
        )
        
    }
    
    private func loadHistory() {
        if let data = UserDefaults.standard.data(forKey: "FoodHistory"),
           let decoded = try? JSONDecoder().decode([HistoryEntry].self, from: data) {
            historyEntries = decoded.sorted(by: { $0.date > $1.date })
            print("Loaded \(historyEntries.count) history entries")
        } else {
            print("No history entries found in UserDefaults")
        }
    }
    
    private func saveHistory() {
        if let encoded = try? JSONEncoder().encode(historyEntries) {
            UserDefaults.standard.set(encoded, forKey: "FoodHistory")
            print("Saved \(historyEntries.count) history entries to UserDefaults")
        } else {
            print("Failed to encode history entries")
        }
    }
} 
