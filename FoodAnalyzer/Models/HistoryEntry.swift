import Foundation

struct HistoryEntry: Codable, Identifiable {
    var id: UUID
    var date: Date
    var entries: [FoodAnalysis]
    var totalCalories: Int
    
    init(id: UUID = UUID(), date: Date = Date(), entries: [FoodAnalysis] = [], totalCalories: Int? = nil) {
        self.id = id
        self.date = date
        self.entries = entries
        self.totalCalories = totalCalories ?? entries.reduce(0) { $0 + $1.calories }
    }
}

extension HistoryEntry {
    static var preview: HistoryEntry {
        HistoryEntry(
            date: Date(),
            entries: [
                FoodAnalysis.preview,
                FoodAnalysis(
                    foodName: "Greek Yogurt",
                    calories: 150,
                    protein: "15g",
                    carbs: "10g",
                    fat: "8g",
                    ingredients: ["Yogurt", "Honey", "Berries"]
                )
            ]
        )
    }
} 