import SwiftUI

struct AnalysisView: View {
    @Binding var analysis: FoodAnalysis?
    @Environment(\.dismiss) private var dismiss
    @State private var editedAnalysis: FoodAnalysis?
    @State private var showingSaveConfirmation = false
    
    var body: some View {
        NavigationView {
            if let analysis = editedAnalysis {
                Form {
                    Section(header: Text("Food Details")) {
                        TextField("Food Name", text: Binding(
                            get: { analysis.foodName },
                            set: { editedAnalysis?.foodName = $0 }
                        ))
                        
                        HStack {
                            Text("Calories")
                            Spacer()
                            TextField("Calories", value: Binding(
                                get: { analysis.calories },
                                set: { editedAnalysis?.calories = $0 }
                            ), format: .number)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                        }
                    }
                    
                    Section(header: Text("Nutritional Information")) {
                        HStack {
                            Text("Protein")
                            Spacer()
                            TextField("Protein", text: Binding(
                                get: { analysis.protein },
                                set: { editedAnalysis?.protein = $0 }
                            ))
                            .multilineTextAlignment(.trailing)
                        }
                        
                        HStack {
                            Text("Carbs")
                            Spacer()
                            TextField("Carbs", text: Binding(
                                get: { analysis.carbs },
                                set: { editedAnalysis?.carbs = $0 }
                            ))
                            .multilineTextAlignment(.trailing)
                        }
                        
                        HStack {
                            Text("Fat")
                            Spacer()
                            TextField("Fat", text: Binding(
                                get: { analysis.fat },
                                set: { editedAnalysis?.fat = $0 }
                            ))
                            .multilineTextAlignment(.trailing)
                        }
                    }
                    
                    Section(header: Text("Ingredients")) {
                        ForEach(analysis.ingredients.indices, id: \.self) { index in
                            TextField("Ingredient", text: Binding(
                                get: { analysis.ingredients[index] },
                                set: { newValue in
                                    var ingredients = analysis.ingredients
                                    ingredients[index] = newValue
                                    editedAnalysis?.ingredients = ingredients
                                }
                            ))
                        }
                        .onDelete { indices in
                            var ingredients = analysis.ingredients
                            ingredients.remove(atOffsets: indices)
                            editedAnalysis?.ingredients = ingredients
                        }
                        
                        Button(action: {
                            var ingredients = analysis.ingredients
                            ingredients.append("")
                            editedAnalysis?.ingredients = ingredients
                        }) {
                            Label("Add Ingredient", systemImage: "plus.circle.fill")
                        }
                    }
                }
                .navigationTitle("Food Analysis")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Save") {
                            self.analysis = editedAnalysis
                            showingSaveConfirmation = true
                        }
                    }
                }
                .alert("Analysis Saved", isPresented: $showingSaveConfirmation) {
                    Button("OK") {
                        dismiss()
                    }
                } message: {
                    Text("Your food analysis has been saved successfully.")
                }
            } else {
                Text("No analysis available")
            }
        }
        .onAppear {
            if let analysis = analysis {
                editedAnalysis = analysis
            }
        }
    }
} 