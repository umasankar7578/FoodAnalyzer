import SwiftUI

struct HistoryView: View {
    @Binding var entries: [HistoryEntry]
    @State private var selectedDate: Date = Date()
    @State private var showingDetail = false
    @State private var selectedEntry: HistoryEntry?
    
    private let calendar = Calendar.current
    
    var body: some View {
        NavigationView {
            ZStack {
                Theme.background
                    .ignoresSafeArea()
                
                VStack(spacing: Theme.Layout.spacing) {
                    DatePicker(
                        "Select Date",
                        selection: $selectedDate,
                        displayedComponents: [.date]
                    )
                    .datePickerStyle(.graphical)
                    .tint(Theme.primary)
                    .padding()
                    .background(Theme.cardBackground)
                    .clipShape(RoundedRectangle(cornerRadius: Theme.Layout.cornerRadius))
                    .shadow(color: Theme.cardShadow, radius: 5)
                    .padding(.horizontal)
                    
                    // Debug information
                    Text("Total Entries: \(entries.count)")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    if let entry = entries.first(where: { calendar.isDate($0.date, inSameDayAs: selectedDate) }) {
                        VStack(spacing: Theme.Layout.spacing) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Total Calories")
                                        .font(Theme.TextStyle.caption)
                                        .foregroundColor(Theme.text.opacity(0.7))
                                    Text("\(entry.totalCalories)")
                                        .font(Theme.TextStyle.title)
                                        .foregroundColor(Theme.primary)
                                }
                                Spacer()
                                Text("kcal")
                                    .font(Theme.TextStyle.body)
                                    .foregroundColor(Theme.text.opacity(0.7))
                            }
                            .padding()
                            .background(Theme.cardBackground)
                            .clipShape(RoundedRectangle(cornerRadius: Theme.Layout.cornerRadius))
                            .shadow(color: Theme.cardShadow, radius: 5)
                            
                            ScrollView {
                                LazyVStack(spacing: Theme.Layout.spacing) {
                                    ForEach(entry.entries) { food in
                                        FoodEntryRow(food: food)
                                            .onTapGesture {
                                                selectedEntry = entry
                                                showingDetail = true
                                            }
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    } else {
                        VStack(spacing: Theme.Layout.spacing) {
                            Image(systemName: "leaf")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                                .foregroundColor(Theme.text.opacity(0.3))
                            
                            Text("No entries for \(selectedDate.formatted(date: .long, time: .omitted))")
                                .font(Theme.TextStyle.body)
                                .foregroundColor(Theme.text.opacity(0.7))
                            
                            Text("Take a photo of your food to start tracking")
                                .font(Theme.TextStyle.caption)
                                .foregroundColor(Theme.text.opacity(0.5))
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Theme.cardBackground)
                        .clipShape(RoundedRectangle(cornerRadius: Theme.Layout.cornerRadius))
                        .shadow(color: Theme.cardShadow, radius: 5)
                        .padding(.horizontal)
                    }
                    
                    Spacer()
                }
                .padding(.top)
            }
            .navigationTitle("History")
            .sheet(isPresented: $showingDetail) {
                if let entry = selectedEntry {
                    DayDetailView(entry: entry)
                }
            }
        }
        .onAppear {
            // Set initial date to today
            selectedDate = Calendar.current.startOfDay(for: Date())
        }
    }
}

struct FoodEntryRow: View {
    let food: FoodAnalysis
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Layout.spacing) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(food.foodName)
                        .font(Theme.TextStyle.heading)
                        .foregroundColor(Theme.text)
                    
                    Text("\(food.calories) calories")
                        .font(Theme.TextStyle.body)
                        .foregroundColor(Theme.primary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(Theme.text.opacity(0.3))
            }
            
            HStack(spacing: Theme.Layout.spacing) {
                NutrientBadge(label: "P", value: food.protein)
                NutrientBadge(label: "C", value: food.carbs)
                NutrientBadge(label: "F", value: food.fat)
            }
        }
        .padding()
        .background(Theme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: Theme.Layout.cornerRadius))
        .shadow(color: Theme.cardShadow, radius: 5)
    }
}

struct NutrientBadge: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack(spacing: 4) {
            Text(label)
                .font(Theme.TextStyle.caption)
                .foregroundColor(Theme.text.opacity(0.7))
            Text(value)
                .font(Theme.TextStyle.body)
                .foregroundColor(Theme.text)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Theme.text.opacity(0.05))
        .clipShape(Capsule())
    }
}

struct DayDetailView: View {
    let entry: HistoryEntry
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                Theme.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: Theme.Layout.spacing) {
                        VStack(spacing: Theme.Layout.spacing) {
                            Text("\(entry.totalCalories)")
                                .font(.system(size: 48, weight: .bold))
                                .foregroundColor(Theme.primary)
                            Text("Total Calories")
                                .font(Theme.TextStyle.caption)
                                .foregroundColor(Theme.text.opacity(0.7))
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Theme.cardBackground)
                        .clipShape(RoundedRectangle(cornerRadius: Theme.Layout.cornerRadius))
                        .shadow(color: Theme.cardShadow, radius: 5)
                        
                        ForEach(entry.entries) { food in
                            VStack(alignment: .leading, spacing: Theme.Layout.spacing) {
                                Text(food.foodName)
                                    .font(Theme.TextStyle.heading)
                                    .foregroundColor(Theme.text)
                                
                                HStack {
                                    Text("\(food.calories) calories")
                                        .font(Theme.TextStyle.body)
                                        .foregroundColor(Theme.primary)
                                    Spacer()
                                    Text(food.timestamp.formatted(date: .omitted, time: .shortened))
                                        .font(Theme.TextStyle.caption)
                                        .foregroundColor(Theme.text.opacity(0.5))
                                }
                                
                                HStack(spacing: Theme.Layout.spacing) {
                                    NutrientBadge(label: "Protein", value: food.protein)
                                    NutrientBadge(label: "Carbs", value: food.carbs)
                                    NutrientBadge(label: "Fat", value: food.fat)
                                }
                                
                                if !food.ingredients.isEmpty {
                                    Text("Ingredients")
                                        .font(Theme.TextStyle.caption)
                                        .foregroundColor(Theme.text.opacity(0.7))
                                    
                                    Text(food.ingredients.joined(separator: ", "))
                                        .font(Theme.TextStyle.body)
                                        .foregroundColor(Theme.text)
                                }
                            }
                            .padding()
                            .background(Theme.cardBackground)
                            .clipShape(RoundedRectangle(cornerRadius: Theme.Layout.cornerRadius))
                            .shadow(color: Theme.cardShadow, radius: 5)
                        }
                    }
                    .padding()
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