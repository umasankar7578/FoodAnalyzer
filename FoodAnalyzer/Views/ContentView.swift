import SwiftUI
import UIKit

struct ContentView: View {
    @StateObject private var viewModel = FoodAnalyzerViewModel()
    @State private var selectedTab = 0
    @State private var showingImagePicker = false
    @State private var showingAnalysis = false
    @State private var showingError = false
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeTab(
                showingCamera: $showingImagePicker,
                showingImagePicker: $showingImagePicker,
                showingAnalysis: $showingAnalysis,
                viewModel: viewModel
            )
            .tabItem {
                Label("Camera", systemImage: "camera")
            }
            .tag(0)
            
            // History Tab
            HistoryView(entries: $viewModel.historyEntries)
                .tabItem {
                    Label("History", systemImage: "calendar")
                }
                .tag(1)
        }
        .tint(Theme.primary)
        .alert("Error", isPresented: $showingError) {
            Button("OK") {
                viewModel.errorMessage = nil
            }
        } message: {
            if let error = viewModel.errorMessage {
                Text(error)
            }
        }
        .onChange(of: viewModel.errorMessage) { error in
            showingError = error != nil
        }
    }
}

// MARK: - Home Tab
struct HomeTab: View {
    @Binding var showingCamera: Bool
    @Binding var showingImagePicker: Bool
    @Binding var showingAnalysis: Bool
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    @ObservedObject var viewModel: FoodAnalyzerViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                Theme.background
                    .ignoresSafeArea()
                
                VStack(spacing: Theme.Layout.spacing) {
                    if let image = viewModel.selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 300)
                            .clipShape(RoundedRectangle(cornerRadius: Theme.Layout.cornerRadius))
                            .shadow(color: Theme.cardShadow, radius: 10)
                            .padding(.horizontal)
                            .transition(.scale.combined(with: .opacity))
                    } else {
                        ZStack {
                            RoundedRectangle(cornerRadius: Theme.Layout.cornerRadius)
                                .fill(Theme.cardBackground)
                                .shadow(color: Theme.cardShadow, radius: 5)
                            
                            VStack(spacing: Theme.Layout.spacing) {
                                Image(systemName: "camera.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 80)
                                    .foregroundColor(Theme.primary)
                                
                                Text("Take a photo of your food")
                                    .font(Theme.TextStyle.heading)
                                    .foregroundColor(Theme.text)
                                
                                Text("Get instant nutritional information")
                                    .font(Theme.TextStyle.caption)
                                    .foregroundColor(Theme.text.opacity(0.7))
                            }
                            .padding()
                        }
                        .frame(height: 300)
                        .padding(.horizontal)
                    }
                    
                    VStack(spacing: Theme.Layout.spacing) {
                        if UIImagePickerController.isSourceTypeAvailable(.camera) {
                            CameraButton(showingCamera: $showingImagePicker, sourceType: $sourceType)
                        }
                        GalleryButton(showingImagePicker: $showingImagePicker, sourceType: $sourceType)
                        
                        if viewModel.selectedImage != nil {
                            Button(action: {
                                Task {
                                    await viewModel.analyzeImage()
                                    showingAnalysis = true
                                }
                            }) {
                                HStack {
                                    if viewModel.isAnalyzing {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    } else {
                                        Image(systemName: "sparkles.magnifyingglass")
                                        Text("Analyze Food")
                                            .font(Theme.TextStyle.body)
                                    }
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background {
                                    RoundedRectangle(cornerRadius: Theme.Layout.cornerRadius)
                                        .fill(Theme.accent)
                                        .shadow(color: Theme.cardShadow, radius: 5)
                                }
                            }
                            .disabled(viewModel.isAnalyzing)
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
                .padding(.top)
            }
            .navigationTitle("Food Analyzer")
            .navigationBarTitleDisplayMode(.large)
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: Binding(
                get: { viewModel.selectedImage },
                set: {
                    viewModel.selectedImage = $0
                    // Don't show analysis immediately, let user press the analyze button
                }
            ), sourceType: $sourceType)
        }
        .sheet(isPresented: $showingAnalysis) {
            if let _ = viewModel.currentAnalysis {
                AnalysisView(analysis: $viewModel.currentAnalysis, viewModel: viewModel)
            }
        }
    }
}

// MARK: - Camera Button
struct CameraButton: View {
    @Binding var showingCamera: Bool
    @Binding var sourceType: UIImagePickerController.SourceType
    
    var body: some View {
        Button(action: { 
            sourceType = .camera
            showingCamera = true 
        }) {
            HStack {
                Image(systemName: "camera.fill")
                    .font(.title2)
                Text("Take Photo")
                    .font(Theme.TextStyle.body)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(Theme.ButtonStyle.primaryButton)
        }
    }
}

// MARK: - Gallery Button
struct GalleryButton: View {
    @Binding var showingImagePicker: Bool
    @Binding var sourceType: UIImagePickerController.SourceType
    
    var body: some View {
        Button(action: { 
            sourceType = .photoLibrary
            showingImagePicker = true 
        }) {
            HStack {
                Image(systemName: "photo.fill")
                    .font(.title2)
                Text("Choose from Gallery")
                    .font(Theme.TextStyle.body)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(Theme.ButtonStyle.secondaryButton)
        }
    }
} 
