import Foundation

struct FoodAnalysis: Codable, Identifiable {
    var id: UUID
    var foodName: String
    var calories: Int
    var protein: String
    var carbs: String
    var fat: String
    var ingredients: [String]
    var timestamp: Date
    
    init(id: UUID = UUID(), foodName: String, calories: Int, protein: String, carbs: String, fat: String, ingredients: [String] = [], timestamp: Date = Date()) {
        self.id = id
        self.foodName = foodName
        self.calories = calories
        self.protein = protein
        self.carbs = carbs
        self.fat = fat
        self.ingredients = ingredients
        self.timestamp = timestamp
    }
}

extension FoodAnalysis {
    static var preview: FoodAnalysis {
        FoodAnalysis(
            foodName: "Chicken Salad",
            calories: 350,
            protein: "25g",
            carbs: "15g",
            fat: "22g",
            ingredients: ["Chicken breast", "Lettuce", "Tomatoes", "Olive oil"]
        )
    }
} 