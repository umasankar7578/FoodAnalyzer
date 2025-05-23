import SwiftUI

struct HistoryView: View {
    @Binding var entries: [HistoryEntry]
    @State private var selectedDate: Date = Date()
    @State private var showingDetail = false
    @State private var selectedEntry: HistoryEntry?
    
    private let calendar = Calendar.current
    
    var body: some View {
        NavigationView {
            VStack {
                DatePicker(
                    "Select Date",
                    selection: $selectedDate,
                    displayedComponents: [.date]
                )
                .datePickerStyle(.graphical)
                .padding()
                
                if let entry = entries.first(where: { calendar.isDate($0.date, inSameDayAs: selectedDate) }) {
                    List {
                        Section(header: Text("Total Calories: \(entry.totalCalories)")) {
                            ForEach(entry.entries) { food in
                                FoodEntryRow(food: food)
                                    .onTapGesture {
                                        // Handle food entry selection
                                    }
                            }
                        }
                    }
                } else {
                    Text("No entries for this date")
                        .foregroundColor(.gray)
                        .padding()
                    Spacer()
                }
            }
            .navigationTitle("History")
            .sheet(isPresented: $showingDetail) {
                if let entry = selectedEntry {
                    DayDetailView(entry: entry)
                }
            }
        }
    }
}

struct FoodEntryRow: View {
    let food: FoodAnalysis
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(food.foodName)
                .font(.headline)
            HStack {
                Text("\(food.calories) cal")
                    .foregroundColor(.secondary)
                Spacer()
                Text("P: \(food.protein) • C: \(food.carbs) • F: \(food.fat)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

struct DayDetailView: View {
    let entry: HistoryEntry
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Summary")) {
                    HStack {
                        Text("Total Calories")
                        Spacer()
                        Text("\(entry.totalCalories)")
                            .bold()
                    }
                }
                
                Section(header: Text("Meals")) {
                    ForEach(entry.entries) { food in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(food.foodName)
                                .font(.headline)
                            
                            Text("Calories: \(food.calories)")
                                .foregroundColor(.secondary)
                            
                            Text("Protein: \(food.protein) • Carbs: \(food.carbs) • Fat: \(food.fat)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            if !food.ingredients.isEmpty {
                                Text("Ingredients: \(food.ingredients.joined(separator: ", "))")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle(entry.date.formatted(date: .long, time: .omitted))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
} 