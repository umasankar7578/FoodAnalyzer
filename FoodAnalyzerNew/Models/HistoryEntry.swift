import Foundation

struct HistoryEntry: Identifiable, Codable {
    let id: UUID
    let date: Date
    var entries: [FoodAnalysis]
    var totalCalories: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case date
        case entries
        case totalCalories
    }
    
    init(id: UUID = UUID(), date: Date, entries: [FoodAnalysis]) {
        self.id = id
        self.date = date
        self.entries = entries
        self.totalCalories = entries.reduce(0) { $0 + $1.calories }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        date = try container.decode(Date.self, forKey: .date)
        entries = try container.decode([FoodAnalysis].self, forKey: .entries)
        totalCalories = try container.decode(Int.self, forKey: .totalCalories)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(date, forKey: .date)
        try container.encode(entries, forKey: .entries)
        try container.encode(totalCalories, forKey: .totalCalories)
    }
    
    mutating func addEntry(_ entry: FoodAnalysis) {
        entries.append(entry)
        totalCalories += entry.calories
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
