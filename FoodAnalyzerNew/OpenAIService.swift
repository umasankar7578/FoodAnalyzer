import Foundation
import UIKit

enum OpenAIError: Error {
    case imageConversionFailed
    case invalidResponse
    case apiError(String)
}

class OpenAIService {
    private let apiKey: String
    private let baseURL = "https://api.openai.com/v1/chat/completions"
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    func analyzeFood(image: UIImage) async throws -> String {
        guard let imageData = image.jpegData(compressionQuality: 0.8)?.base64EncodedString() else {
            throw OpenAIError.imageConversionFailed
        }

        let messages: [[String: Any]] = [[
            "role": "user",
            "content": [
                ["type": "text", "text": "Analyze this image of food and provide detailed nutritional information. Return the response in this format:\n\nFood Name\nCalories: X\nProtein: Xg\nCarbs: Xg\nFat: Xg\nIngredients: ingredient1, ingredient2, ..."],
                ["type": "image_url", "image_url": ["url": "data:image/jpeg;base64,\(imageData)"]]
            ]
        ]]

        let body: [String: Any] = [
            "model": "gpt-4-vision-preview",
            "messages": messages,
            "max_tokens": 1000,
            "temperature": 0.2
        ]

        var request = URLRequest(url: URL(string: baseURL)!)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        print("Sending request to OpenAI...")
        let (data, response) = try await URLSession.shared.data(for: request)
        print("Received response from OpenAI")
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw OpenAIError.invalidResponse
        }
        
        // Print response for debugging
        print("Response status code: \(httpResponse.statusCode)")
        print("Response headers: \(httpResponse.allHeaderFields)")

        return ""

        
//        if httpResponse.statusCode != 200 {
//            if let errorResponse = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
//               let error = errorResponse["error"] as? [String: Any],
//               let message = error["message"] as? String {
//                throw OpenAIError.apiError("API Error (\(httpResponse.statusCode)): \(message)")
//            } else {
//                throw OpenAIError.apiError("API Error: Status code \(httpResponse.statusCode)")
//            }
//        }
//        
//        do {
//            let response = try JSONDecoder().decode(OpenAIResponse.self, from: data)
//            return response.choices.first?.message.content ?? "No analysis available"
//        } catch {
//            print("Decoding error: \(error)")
//            print("Response data: \(String(data: data, encoding: .utf8) ?? "Unable to read response")")
//            throw error
//        }
    }
}

struct OpenAIResponse: Codable {
    let choices: [Choice]
}

struct Choice: Codable {
    let message: Message
}

struct Message: Codable {
    let content: String
} 
