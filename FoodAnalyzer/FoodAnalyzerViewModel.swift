import Foundation
import UIKit
import SwiftUI

@MainActor
class FoodAnalyzerViewModel: ObservableObject {
    @Published var selectedImage: UIImage?
    @Published var currentAnalysis: FoodAnalysis?
    @Published var isAnalyzing = false
    @Published var errorMessage: String?
    @Published var historyEntries: [HistoryEntry] = []
    
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
        
        if var existingEntry = historyEntries.first(where: { calendar.isDate($0.date, inSameDayAs: today) }) {
            existingEntry.entries.append(analysis)
            existingEntry.totalCalories += analysis.calories
            if let index = historyEntries.firstIndex(where: { calendar.isDate($0.date, inSameDayAs: today) }) {
                historyEntries[index] = existingEntry
            }
        } else {
            let newEntry = HistoryEntry(date: today, entries: [analysis])
            historyEntries.append(newEntry)
        }
        
        saveHistory()
        clearAnalysis()
    }
    
    func clearAnalysis() {
        selectedImage = nil
        currentAnalysis = nil
        errorMessage = nil  // Make sure to clear error message when clearing analysis
    }
    
    private func parseAnalysis(_ text: String) -> FoodAnalysis {
        // This is a simple parser. You might want to make it more sophisticated
        var foodName = "Unknown Food"
        var calories = 0
        var protein = "0g"
        var carbs = "0g"
        var fat = "0g"
        var ingredients: [String] = []
        
        let lines = text.components(separatedBy: .newlines)
        for line in lines {
            let lowercased = line.lowercased()
            if lowercased.contains("calories") {
                let numbers = line.components(separatedBy: CharacterSet.decimalDigits.inverted)
                    .filter { !$0.isEmpty }
                if let firstNumber = numbers.first,
                   let cal = Int(firstNumber) {
                    calories = cal
                }
            } else if lowercased.contains("protein") {
                protein = line.components(separatedBy: ":").last?.trimmingCharacters(in: .whitespaces) ?? "0g"
            } else if lowercased.contains("carb") {
                carbs = line.components(separatedBy: ":").last?.trimmingCharacters(in: .whitespaces) ?? "0g"
            } else if lowercased.contains("fat") {
                fat = line.components(separatedBy: ":").last?.trimmingCharacters(in: .whitespaces) ?? "0g"
            } else if lowercased.contains("ingredients") {
                let ingredientList = line.components(separatedBy: ":").last?.trimmingCharacters(in: .whitespaces) ?? ""
                ingredients = ingredientList.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }
            } else if foodName == "Unknown Food" && !line.isEmpty {
                foodName = line.trimmingCharacters(in: .whitespaces)
            }
        }
        
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
            historyEntries = decoded
        }
    }
    
    private func saveHistory() {
        if let encoded = try? JSONEncoder().encode(historyEntries) {
            UserDefaults.standard.set(encoded, forKey: "FoodHistory")
        }
    }
} 
