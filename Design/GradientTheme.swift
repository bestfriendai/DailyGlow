import SwiftUI

// MARK: - Premium Gradient Theme System
// Rich, deep, high-contrast gradients for a $100 app feel

struct GradientTheme {
    
    // MARK: - Time-Based Background Gradients (Dark & Rich)
    
    static let morning: [Color] = [
        Color(red: 0.18, green: 0.12, blue: 0.25),
        Color(red: 0.12, green: 0.08, blue: 0.18)
    ]
    
    static let afternoon: [Color] = [
        Color(red: 0.15, green: 0.1, blue: 0.22),
        Color(red: 0.08, green: 0.06, blue: 0.14)
    ]
    
    static let evening: [Color] = [
        Color(red: 0.12, green: 0.08, blue: 0.2),
        Color(red: 0.06, green: 0.04, blue: 0.12)
    ]
    
    static let night: [Color] = [
        Color(red: 0.06, green: 0.04, blue: 0.12),
        Color(red: 0.02, green: 0.02, blue: 0.06)
    ]
    
    // MARK: - Card Accent Gradients (Vibrant overlays)
    
    static let cardSunrise: [Color] = [
        Color(red: 1.0, green: 0.6, blue: 0.3).opacity(0.9),
        Color(red: 1.0, green: 0.4, blue: 0.5).opacity(0.9)
    ]
    
    static let cardOcean: [Color] = [
        Color(red: 0.2, green: 0.7, blue: 0.9).opacity(0.9),
        Color(red: 0.4, green: 0.5, blue: 0.95).opacity(0.9)
    ]
    
    static let cardForest: [Color] = [
        Color(red: 0.2, green: 0.75, blue: 0.5).opacity(0.9),
        Color(red: 0.3, green: 0.6, blue: 0.7).opacity(0.9)
    ]
    
    static let cardCosmic: [Color] = [
        Color(red: 0.6, green: 0.3, blue: 0.9).opacity(0.9),
        Color(red: 0.9, green: 0.4, blue: 0.7).opacity(0.9)
    ]
    
    static let cardGold: [Color] = [
        Color(red: 1.0, green: 0.8, blue: 0.3).opacity(0.9),
        Color(red: 1.0, green: 0.6, blue: 0.25).opacity(0.9)
    ]
    
    static let cardRose: [Color] = [
        Color(red: 1.0, green: 0.5, blue: 0.6).opacity(0.9),
        Color(red: 0.9, green: 0.35, blue: 0.55).opacity(0.9)
    ]
    
    // All card gradients for random selection
    static let allCardGradients: [[Color]] = [
        cardSunrise, cardOcean, cardForest, cardCosmic, cardGold, cardRose
    ]
    
    // MARK: - Category Gradients
    
    static func gradientForCategory(_ category: String) -> [Color] {
        switch category.lowercased() {
        case "self-love", "self love", "selflove":
            return [Color.categorySelfLove, Color.categorySelfLove.opacity(0.7)]
        case "success":
            return [Color.categorySuccess, Color(red: 0.2, green: 0.7, blue: 0.4)]
        case "health":
            return [Color.categoryHealth, Color(red: 0.2, green: 0.7, blue: 0.7)]
        case "relationships":
            return [Color.categoryRelationships, Color(red: 0.9, green: 0.4, blue: 0.6)]
        case "abundance":
            return [Color.categoryAbundance, Color(red: 0.95, green: 0.65, blue: 0.2)]
        case "confidence":
            return [Color.categoryConfidence, Color(red: 0.5, green: 0.35, blue: 0.9)]
        case "gratitude":
            return [Color.categoryGratitude, Color(red: 0.95, green: 0.5, blue: 0.3)]
        case "peace":
            return [Color.categoryPeace, Color(red: 0.4, green: 0.6, blue: 0.9)]
        case "creativity":
            return [Color.categoryCreativity, Color(red: 0.9, green: 0.4, blue: 0.75)]
        case "mindfulness":
            return [Color.categoryMindfulness, Color(red: 0.5, green: 0.8, blue: 0.7)]
        case "strength":
            return [Color.categoryStrength, Color(red: 0.95, green: 0.4, blue: 0.25)]
        case "joy":
            return [Color.categoryJoy, Color(red: 0.95, green: 0.75, blue: 0.3)]
        default:
            return [Color.glowGold, Color.glowGoldDark]
        }
    }
    
    // MARK: - Mood Gradients
    
    static func gradientForMood(_ mood: String) -> [Color] {
        switch mood.lowercased() {
        case "energized":
            return [Color.moodEnergized, Color(red: 1.0, green: 0.35, blue: 0.2)]
        case "calm":
            return [Color.moodCalm, Color(red: 0.35, green: 0.55, blue: 0.9)]
        case "focused":
            return [Color.moodFocused, Color(red: 0.45, green: 0.3, blue: 0.85)]
        case "happy":
            return [Color.moodHappy, Color(red: 1.0, green: 0.65, blue: 0.2)]
        case "grateful":
            return [Color.moodGrateful, Color(red: 0.95, green: 0.45, blue: 0.4)]
        case "peaceful":
            return [Color.moodPeaceful, Color(red: 0.4, green: 0.75, blue: 0.65)]
        case "motivated":
            return [Color.moodMotivated, Color(red: 0.95, green: 0.3, blue: 0.35)]
        case "confident":
            return [Color.moodConfident, Color(red: 0.55, green: 0.35, blue: 0.9)]
        default:
            return [Color.glowPurple, Color.glowPurpleDark]
        }
    }
    
    // MARK: - Time-Based Gradient Selection
    
    static func currentBackgroundGradient() -> LinearGradient {
        let hour = Calendar.current.component(.hour, from: Date())
        let colors: [Color]
        
        switch hour {
        case 5..<12:
            colors = morning
        case 12..<17:
            colors = afternoon
        case 17..<21:
            colors = evening
        default:
            colors = night
        }
        
        return LinearGradient(
            colors: colors,
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    static func randomCardGradient() -> LinearGradient {
        let colors = allCardGradients.randomElement() ?? cardSunrise
        return LinearGradient(
            colors: colors,
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

// MARK: - Gradient View Modifiers

struct GlowingGradient: ViewModifier {
    let colors: [Color]
    let blur: CGFloat
    
    func body(content: Content) -> some View {
        content
            .background(
                LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing)
                    .blur(radius: blur)
            )
    }
}

extension View {
    func glowingGradient(_ colors: [Color], blur: CGFloat = 20) -> some View {
        modifier(GlowingGradient(colors: colors, blur: blur))
    }
}
