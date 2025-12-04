import SwiftUI

// MARK: - Typography System

extension Font {
    // MARK: - Display
    static let displayLarge = Font.system(size: 48, weight: .bold, design: .rounded)
    static let displayMedium = Font.system(size: 36, weight: .bold, design: .rounded)
    static let displaySmall = Font.system(size: 28, weight: .bold, design: .rounded)
    
    // MARK: - Headlines
    static let headlineLarge = Font.system(size: 24, weight: .bold)
    static let headlineMedium = Font.system(size: 20, weight: .semibold)
    static let headlineSmall = Font.system(size: 18, weight: .semibold)
    
    // MARK: - Body
    static let bodyLarge = Font.system(size: 17, weight: .regular)
    static let bodyMedium = Font.system(size: 15, weight: .regular)
    static let bodySmall = Font.system(size: 13, weight: .regular)
    
    // MARK: - Labels
    static let labelLarge = Font.system(size: 14, weight: .semibold)
    static let labelMedium = Font.system(size: 12, weight: .medium)
    static let labelSmall = Font.system(size: 11, weight: .medium)
    
    // MARK: - Affirmation Text
    static let affirmationLarge = Font.system(size: 28, weight: .bold, design: .rounded)
    static let affirmationMedium = Font.system(size: 24, weight: .semibold, design: .rounded)
    static let affirmationSmall = Font.system(size: 20, weight: .semibold, design: .rounded)
}

// MARK: - Text Styles View Modifier

struct GlowTextStyle: ViewModifier {
    let style: TextStyle
    
    enum TextStyle {
        case displayLarge, displayMedium, displaySmall
        case headlineLarge, headlineMedium, headlineSmall
        case bodyLarge, bodyMedium, bodySmall
        case labelLarge, labelMedium, labelSmall
        case affirmation
    }
    
    func body(content: Content) -> some View {
        switch style {
        case .displayLarge:
            content.font(.displayLarge).foregroundColor(.textPrimary)
        case .displayMedium:
            content.font(.displayMedium).foregroundColor(.textPrimary)
        case .displaySmall:
            content.font(.displaySmall).foregroundColor(.textPrimary)
        case .headlineLarge:
            content.font(.headlineLarge).foregroundColor(.textPrimary)
        case .headlineMedium:
            content.font(.headlineMedium).foregroundColor(.textPrimary)
        case .headlineSmall:
            content.font(.headlineSmall).foregroundColor(.textPrimary)
        case .bodyLarge:
            content.font(.bodyLarge).foregroundColor(.textSecondary)
        case .bodyMedium:
            content.font(.bodyMedium).foregroundColor(.textSecondary)
        case .bodySmall:
            content.font(.bodySmall).foregroundColor(.textTertiary)
        case .labelLarge:
            content.font(.labelLarge).foregroundColor(.textSecondary)
        case .labelMedium:
            content.font(.labelMedium).foregroundColor(.textTertiary)
        case .labelSmall:
            content.font(.labelSmall).foregroundColor(.textTertiary)
        case .affirmation:
            content.font(.affirmationLarge).foregroundColor(.textPrimary)
        }
    }
}

extension View {
    func glowText(_ style: GlowTextStyle.TextStyle) -> some View {
        modifier(GlowTextStyle(style: style))
    }
}
