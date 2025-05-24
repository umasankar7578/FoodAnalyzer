import SwiftUI

struct Theme {
    static let primary = Color("Primary")
    static let secondary = Color("Secondary")
    static let accent = Color("Accent")
    static let background = Color("Background")
    static let text = Color("Text")
    static let error = Color.red
    
    static let cardBackground = Color("CardBackground")
    static let cardShadow = Color.black.opacity(0.1)
    
    struct ButtonStyle {
        static var primaryButton: some View {
            AnyView(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Theme.primary)
                    .shadow(color: Theme.cardShadow, radius: 5, x: 0, y: 2)
            )
        }
        
        static var secondaryButton: some View {
            AnyView(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Theme.secondary)
                    .shadow(color: Theme.cardShadow, radius: 5, x: 0, y: 2)
            )
        }
    }
    
    struct TextStyle {
        static let title: Font = .system(size: 28, weight: .bold)
        static let heading: Font = .system(size: 22, weight: .semibold)
        static let body: Font = .system(size: 16)
        static let caption: Font = .system(size: 14)
    }
    
    struct Layout {
        static let padding: CGFloat = 16
        static let cornerRadius: CGFloat = 15
        static let spacing: CGFloat = 12
    }
} 
