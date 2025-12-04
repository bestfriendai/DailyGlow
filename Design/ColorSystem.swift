import SwiftUI

// MARK: - DailyGlow Premium Color System
// Dark, rich, high-contrast colors that DON'T hurt your eyes

extension Color {
    
    // MARK: - Core Brand Colors (Deep & Rich)
    static let glowGold = Color(red: 1.0, green: 0.78, blue: 0.35)
    static let glowGoldLight = Color(red: 1.0, green: 0.88, blue: 0.55)
    static let glowGoldDark = Color(red: 0.85, green: 0.6, blue: 0.15)
    
    static let glowPurple = Color(red: 0.55, green: 0.35, blue: 0.95)
    static let glowPurpleLight = Color(red: 0.7, green: 0.55, blue: 1.0)
    static let glowPurpleDark = Color(red: 0.35, green: 0.2, blue: 0.7)
    
    static let glowCoral = Color(red: 1.0, green: 0.45, blue: 0.45)
    static let glowTeal = Color(red: 0.2, green: 0.85, blue: 0.8)
    static let glowMint = Color(red: 0.4, green: 0.95, blue: 0.7)
    
    // MARK: - Background Colors (DARK - No More Eye Pain!)
    static let backgroundDark = Color(red: 0.06, green: 0.06, blue: 0.12)
    static let backgroundMedium = Color(red: 0.1, green: 0.1, blue: 0.18)
    static let backgroundLight = Color(red: 0.14, green: 0.14, blue: 0.22)
    static let backgroundCard = Color(red: 0.12, green: 0.12, blue: 0.2)
    
    // Alternative warm dark backgrounds
    static let backgroundWarmDark = Color(red: 0.1, green: 0.08, blue: 0.06)
    static let backgroundDeepPurple = Color(red: 0.08, green: 0.06, blue: 0.14)
    static let backgroundDeepBlue = Color(red: 0.04, green: 0.06, blue: 0.12)
    
    // MARK: - Text Colors (HIGH CONTRAST!)
    static let textPrimary = Color.white
    static let textSecondary = Color.white.opacity(0.75)
    static let textTertiary = Color.white.opacity(0.5)
    static let textMuted = Color.white.opacity(0.35)
    
    // Colored text for emphasis
    static let textGold = glowGold
    static let textAccent = glowPurpleLight
    
    // MARK: - Card & Surface Colors
    static let cardDark = Color.white.opacity(0.06)
    static let cardMedium = Color.white.opacity(0.1)
    static let cardLight = Color.white.opacity(0.15)
    static let cardBorder = Color.white.opacity(0.12)
    static let cardBorderLight = Color.white.opacity(0.2)
    
    // Glass effect
    static let glassBackground = Color.white.opacity(0.08)
    static let glassBorder = Color.white.opacity(0.15)
    static let glassHighlight = Color.white.opacity(0.25)
    
    // MARK: - Category Colors (Vibrant, Saturated)
    static let categorySelfLove = Color(red: 1.0, green: 0.4, blue: 0.5)
    static let categorySuccess = Color(red: 0.3, green: 0.9, blue: 0.5)
    static let categoryHealth = Color(red: 0.3, green: 0.85, blue: 0.85)
    static let categoryRelationships = Color(red: 1.0, green: 0.5, blue: 0.7)
    static let categoryAbundance = Color(red: 1.0, green: 0.8, blue: 0.3)
    static let categoryConfidence = Color(red: 0.65, green: 0.5, blue: 1.0)
    static let categoryGratitude = Color(red: 1.0, green: 0.65, blue: 0.4)
    static let categoryPeace = Color(red: 0.5, green: 0.75, blue: 1.0)
    static let categoryCreativity = Color(red: 1.0, green: 0.5, blue: 0.85)
    static let categoryMindfulness = Color(red: 0.6, green: 0.9, blue: 0.8)
    static let categoryStrength = Color(red: 1.0, green: 0.55, blue: 0.35)
    static let categoryJoy = Color(red: 1.0, green: 0.85, blue: 0.4)
    
    // MARK: - Mood Colors (Rich & Expressive)
    static let moodEnergized = Color(red: 1.0, green: 0.5, blue: 0.25)
    static let moodCalm = Color(red: 0.45, green: 0.7, blue: 1.0)
    static let moodFocused = Color(red: 0.6, green: 0.45, blue: 1.0)
    static let moodHappy = Color(red: 1.0, green: 0.8, blue: 0.3)
    static let moodGrateful = Color(red: 1.0, green: 0.6, blue: 0.5)
    static let moodPeaceful = Color(red: 0.5, green: 0.85, blue: 0.75)
    static let moodMotivated = Color(red: 1.0, green: 0.45, blue: 0.45)
    static let moodConfident = Color(red: 0.7, green: 0.5, blue: 1.0)
    
    // MARK: - Semantic Colors
    static let success = Color(red: 0.3, green: 0.95, blue: 0.5)
    static let warning = Color(red: 1.0, green: 0.8, blue: 0.3)
    static let error = Color(red: 1.0, green: 0.4, blue: 0.4)
    static let info = Color(red: 0.4, green: 0.7, blue: 1.0)
    
    // MARK: - Premium/Pro Colors
    static let premiumGold = LinearGradient(
        colors: [Color(red: 1.0, green: 0.85, blue: 0.4), Color(red: 1.0, green: 0.65, blue: 0.2)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let premiumPurple = LinearGradient(
        colors: [Color(red: 0.7, green: 0.5, blue: 1.0), Color(red: 0.5, green: 0.3, blue: 0.9)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    // MARK: - Button Colors
    static let buttonPrimary = glowGold
    static let buttonSecondary = Color.white.opacity(0.15)
    static let buttonDestructive = error
    static let buttonDisabled = Color.white.opacity(0.2)
    
    // MARK: - Tab Bar
    static let tabBarBackground = Color(red: 0.08, green: 0.08, blue: 0.14).opacity(0.95)
    static let tabBarSelected = glowGold
    static let tabBarUnselected = Color.white.opacity(0.4)
    
    // MARK: - Streak & Achievement
    static let streakFlame = Color(red: 1.0, green: 0.5, blue: 0.2)
    static let streakGlow = Color(red: 1.0, green: 0.7, blue: 0.3)
    static let achievementBronze = Color(red: 0.8, green: 0.5, blue: 0.2)
    static let achievementSilver = Color(red: 0.75, green: 0.75, blue: 0.8)
    static let achievementGold = Color(red: 1.0, green: 0.85, blue: 0.35)
    static let achievementPlatinum = Color(red: 0.9, green: 0.95, blue: 1.0)
}

// MARK: - Gradient Presets
extension LinearGradient {
    
    // Primary app gradients
    static let glowSunrise = LinearGradient(
        colors: [Color(red: 1.0, green: 0.6, blue: 0.3), Color(red: 1.0, green: 0.4, blue: 0.5)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let glowSunset = LinearGradient(
        colors: [Color(red: 0.95, green: 0.4, blue: 0.5), Color(red: 0.6, green: 0.3, blue: 0.8)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let glowNight = LinearGradient(
        colors: [Color(red: 0.15, green: 0.1, blue: 0.3), Color(red: 0.05, green: 0.05, blue: 0.15)],
        startPoint: .top,
        endPoint: .bottom
    )
    
    static let glowAurora = LinearGradient(
        colors: [Color(red: 0.3, green: 0.9, blue: 0.7), Color(red: 0.4, green: 0.5, blue: 1.0)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let glowCosmic = LinearGradient(
        colors: [Color(red: 0.5, green: 0.3, blue: 0.9), Color(red: 0.9, green: 0.3, blue: 0.6)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    // Card gradients
    static let cardGradient = LinearGradient(
        colors: [Color.white.opacity(0.12), Color.white.opacity(0.06)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    // Button gradients
    static let buttonGold = LinearGradient(
        colors: [Color.glowGold, Color.glowGoldDark],
        startPoint: .top,
        endPoint: .bottom
    )
    
    static let buttonPurple = LinearGradient(
        colors: [Color.glowPurple, Color.glowPurpleDark],
        startPoint: .top,
        endPoint: .bottom
    )
}

// MARK: - View Extension for Easy Backgrounds
extension View {
    func glowBackground(_ style: GlowBackgroundStyle = .default) -> some View {
        self.background(style.gradient.ignoresSafeArea())
    }
}

enum GlowBackgroundStyle {
    case `default`, sunrise, sunset, night, aurora, cosmic, deepPurple, warmDark
    
    var gradient: LinearGradient {
        switch self {
        case .default:
            return LinearGradient(
                colors: [Color.backgroundDark, Color.backgroundDeepPurple],
                startPoint: .top,
                endPoint: .bottom
            )
        case .sunrise:
            return LinearGradient(
                colors: [Color(red: 0.15, green: 0.1, blue: 0.2), Color(red: 0.2, green: 0.1, blue: 0.15)],
                startPoint: .top,
                endPoint: .bottom
            )
        case .sunset:
            return LinearGradient(
                colors: [Color(red: 0.18, green: 0.08, blue: 0.15), Color(red: 0.1, green: 0.06, blue: 0.12)],
                startPoint: .top,
                endPoint: .bottom
            )
        case .night:
            return LinearGradient(
                colors: [Color(red: 0.05, green: 0.05, blue: 0.12), Color(red: 0.02, green: 0.02, blue: 0.08)],
                startPoint: .top,
                endPoint: .bottom
            )
        case .aurora:
            return LinearGradient(
                colors: [Color(red: 0.08, green: 0.12, blue: 0.15), Color(red: 0.05, green: 0.08, blue: 0.12)],
                startPoint: .top,
                endPoint: .bottom
            )
        case .cosmic:
            return LinearGradient(
                colors: [Color(red: 0.12, green: 0.08, blue: 0.18), Color(red: 0.06, green: 0.04, blue: 0.1)],
                startPoint: .top,
                endPoint: .bottom
            )
        case .deepPurple:
            return LinearGradient(
                colors: [Color.backgroundDeepPurple, Color.backgroundDark],
                startPoint: .top,
                endPoint: .bottom
            )
        case .warmDark:
            return LinearGradient(
                colors: [Color(red: 0.12, green: 0.1, blue: 0.08), Color(red: 0.06, green: 0.05, blue: 0.04)],
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }
}
