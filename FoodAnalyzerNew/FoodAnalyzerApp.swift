//
//  FoodAnalyzerApp.swift
//  FoodAnalyzer
//
//  Created by uma sankar on 22/05/25.
//

import SwiftUI

@main
struct FoodAnalyzerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    init() {
        // Ensure proper configuration of Info.plist settings
        #if DEBUG
        print("Bundle path: \(Bundle.main.bundlePath)")
        print("Info.plist path: \(Bundle.main.infoDictionary?["CFBundleInfoDictionaryVersion"] ?? "Not found")")
        #endif
    }
}
