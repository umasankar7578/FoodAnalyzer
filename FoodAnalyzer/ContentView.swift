//
//  ContentView.swift
//  FoodAnalyzer
//
//  Created by uma sankar on 22/05/25.
//

import SwiftUI
import UIKit

struct ContentView: View {
    @StateObject private var viewModel = FoodAnalyzerViewModel()
    @State private var selectedTab = 0
    @State private var showingImagePicker = false
    @State private var showingAnalysis = false
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    @State private var showingError = false
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Camera Tab
            NavigationView {
                VStack(spacing: 20) {
                    if let image = viewModel.selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 300)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    } else {
                        Image(systemName: "camera.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .foregroundColor(.gray)
                            .padding()
                    }
                    
                    HStack(spacing: 20) {
                        if UIImagePickerController.isSourceTypeAvailable(.camera) {
                            Button(action: {
                                sourceType = .camera
                                showingImagePicker = true
                            }) {
                                HStack {
                                    Image(systemName: "camera")
                                    Text("Take Photo")
                                }
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                            }
                        }
                        
                        Button(action: {
                            sourceType = .photoLibrary
                            showingImagePicker = true
                        }) {
                            HStack {
                                Image(systemName: "photo.on.rectangle")
                                Text("Choose Photo")
                            }
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.purple)
                            .cornerRadius(10)
                        }
                    }
                    
                    if viewModel.selectedImage != nil {
                        Button(action: {
                            Task {
                                await viewModel.analyzeImage()
                                showingAnalysis = true
                            }
                        }) {
                            HStack {
                                Image(systemName: "magnifyingglass")
                                Text("Analyze")
                            }
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(10)
                        }
                        .disabled(viewModel.isAnalyzing)
                    }
                    
                    if viewModel.isAnalyzing {
                        ProgressView("Analyzing food...")
                            .progressViewStyle(CircularProgressViewStyle())
                    }
                    
                    Spacer()
                }
                .padding()
                .navigationTitle("Food Analyzer")
            }
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
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: $viewModel.selectedImage, sourceType: $sourceType)
        }
        .sheet(isPresented: $showingAnalysis) {
            if let _ = viewModel.currentAnalysis {
                AnalysisView(analysis: $viewModel.currentAnalysis)
            }
        }
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

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.presentationMode) var presentationMode
    @Binding var sourceType: UIImagePickerController.SourceType
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        picker.allowsEditing = false
        
        if sourceType == .camera {
            if !UIImagePickerController.isSourceTypeAvailable(.camera) {
                picker.sourceType = .photoLibrary
            }
        }
        
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.image = image
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

#Preview {
    ContentView()
}
