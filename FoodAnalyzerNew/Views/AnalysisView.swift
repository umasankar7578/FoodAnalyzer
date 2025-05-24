import SwiftUI

struct AnalysisView: View {
    @ObservedObject var viewModel: FoodAnalyzerViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                Theme.background
                    .ignoresSafeArea()
                
                if viewModel.isAnalyzing {
                    VStack(spacing: Theme.Layout.spacing) {
                        ProgressView()
                            .scaleEffect(1.5)
                            .tint(Theme.primary)
                        Text("Analyzing your food...")
                            .font(Theme.TextStyle.body)
                            .foregroundColor(Theme.text)
                    }
                } else if let analysis = viewModel.currentAnalysis {
                    ScrollView {
                        VStack(spacing: Theme.Layout.spacing) {
                            if let image = viewModel.selectedImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .clipShape(RoundedRectangle(cornerRadius: Theme.Layout.cornerRadius))
                                    .shadow(color: Theme.cardShadow, radius: 5)
                            }
                            
                            VStack(alignment: .leading, spacing: Theme.Layout.spacing) {
                                Text(analysis.foodName)
                                    .font(Theme.TextStyle.title)
                                    .foregroundColor(Theme.text)
                                
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text("Calories")
                                            .font(Theme.TextStyle.caption)
                                            .foregroundColor(Theme.text.opacity(0.7))
                                        Text("\(analysis.calories)")
                                            .font(Theme.TextStyle.heading)
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
                                
                                VStack(alignment: .leading, spacing: Theme.Layout.spacing) {
                                    Text("Nutrition Facts")
                                        .font(Theme.TextStyle.heading)
                                        .foregroundColor(Theme.text)
                                    
                                    HStack(spacing: Theme.Layout.spacing) {
                                        NutrientCard(label: "Protein", value: analysis.protein)
                                        NutrientCard(label: "Carbs", value: analysis.carbs)
                                        NutrientCard(label: "Fat", value: analysis.fat)
                                    }
                                }
                                
                                if !analysis.ingredients.isEmpty {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Ingredients")
                                            .font(Theme.TextStyle.heading)
                                            .foregroundColor(Theme.text)
                                        
                                        ForEach(analysis.ingredients, id: \.self) { ingredient in
                                            Text("• \(ingredient)")
                                                .font(Theme.TextStyle.body)
                                                .foregroundColor(Theme.text)
                                        }
                                    }
                                }
                            }
                            .padding()
                            .background(Theme.cardBackground)
                            .clipShape(RoundedRectangle(cornerRadius: Theme.Layout.cornerRadius))
                            .shadow(color: Theme.cardShadow, radius: 5)
                        }
                        .padding()
                    }
                } else if let error = viewModel.errorMessage {
                    VStack(spacing: Theme.Layout.spacing) {
                        Image(systemName: "exclamationmark.triangle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .foregroundColor(Theme.error)
                        
                        Text(error)
                            .font(Theme.TextStyle.body)
                            .foregroundColor(Theme.text)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                }
            }
            .navigationTitle("Analysis")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        viewModel.clearAnalysis()
                        dismiss()
                    }
                }
                
                if viewModel.currentAnalysis != nil {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Save") {
                            viewModel.saveAnalysis()
                            dismiss()
                        }
                    }
                }
            }
        }
    }
}

struct NutrientCard: View {
    let label: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(Theme.TextStyle.caption)
                .foregroundColor(Theme.text.opacity(0.7))
            Text(value)
                .font(Theme.TextStyle.body)
                .foregroundColor(Theme.text)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Theme.text.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: Theme.Layout.cornerRadius))
    }
} 
