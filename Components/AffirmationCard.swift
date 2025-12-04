import SwiftUI

// MARK: - Premium Affirmation Card
// Beautiful card with image background support

struct AffirmationCard: View {
    let affirmation: Affirmation
    var showCategory: Bool = true
    var onFavorite: (() -> Void)? = nil
    var onShare: (() -> Void)? = nil
    
    @State private var isPressed = false
    
    // Get a background image - uses ALL 165 generated backgrounds!
    private var backgroundImageName: String {
        // Total backgrounds available: Bg1 through Bg165
        let totalBackgrounds = 165
        
        // Use affirmation ID hash to pick a background (deterministic per affirmation)
        let index = (abs(affirmation.id.hashValue) % totalBackgrounds) + 1
        return "Bg\(index)"
    }
    
    private var categoryGradient: [Color] {
        GradientTheme.gradientForCategory(affirmation.category.rawValue)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                // Background Image
                Image(backgroundImageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 28))
                
                // Dark overlay for text readability
                RoundedRectangle(cornerRadius: 28)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.black.opacity(0.3),
                                Color.black.opacity(0.5),
                                Color.black.opacity(0.6)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                
                // Content
                VStack(spacing: 16) {
                    // Category badge
                    if showCategory {
                        HStack {
                            Label(affirmation.category.displayName, systemImage: affirmation.category.icon)
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(.white.opacity(0.9))
                                .padding(.horizontal, 14)
                                .padding(.vertical, 8)
                                .background(
                                    Capsule()
                                        .fill(Color.black.opacity(0.25))
                                        .overlay(
                                            Capsule()
                                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                        )
                                )
                            
                            Spacer()
                        }
                    }
                    
                    Spacer()
                    
                    // Affirmation text
                    Text(affirmation.text)
                        .font(.system(size: 26, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
                        .padding(.horizontal, 8)
                    
                    Spacer()
                    
                    // Action buttons
                    HStack(spacing: 20) {
                        // Share button
                        Button(action: { onShare?() }) {
                            Image(systemName: "square.and.arrow.up")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(.white.opacity(0.9))
                                .frame(width: 50, height: 50)
                                .background(
                                    Circle()
                                        .fill(Color.black.opacity(0.2))
                                        .overlay(
                                            Circle()
                                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                        )
                                )
                        }
                        
                        // Favorite button
                        Button(action: { onFavorite?() }) {
                            Image(systemName: affirmation.isFavorite ? "heart.fill" : "heart")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(affirmation.isFavorite ? .red : .white.opacity(0.9))
                                .frame(width: 50, height: 50)
                                .background(
                                    Circle()
                                        .fill(Color.black.opacity(0.2))
                                        .overlay(
                                            Circle()
                                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                        )
                                )
                        }
                    }
                    
                    // Brand watermark
                    HStack {
                        Spacer()
                        HStack(spacing: 4) {
                            Image(systemName: "sun.max.fill")
                                .font(.system(size: 10))
                            Text("Daily Glow")
                                .font(.system(size: 11, weight: .medium))
                        }
                        .foregroundColor(.white.opacity(0.5))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(Color.black.opacity(0.15))
                        )
                    }
                }
                .padding(24)
            }
            .aspectRatio(0.7, contentMode: .fit)
            .scaleEffect(isPressed ? 0.98 : 1)
            .animation(.spring(response: 0.3), value: isPressed)
        }
    }
}

// MARK: - Compact Affirmation Card (for lists)

struct CompactAffirmationCard: View {
    let affirmation: Affirmation
    var onTap: (() -> Void)? = nil
    var onFavorite: (() -> Void)? = nil
    
    private var categoryGradient: [Color] {
        GradientTheme.gradientForCategory(affirmation.category.rawValue)
    }
    
    var body: some View {
        Button(action: { onTap?() }) {
            HStack(spacing: 16) {
                // Category color indicator
                RoundedRectangle(cornerRadius: 6)
                    .fill(
                        LinearGradient(
                            colors: categoryGradient,
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 4)
                
                // Content
                VStack(alignment: .leading, spacing: 6) {
                    Text(affirmation.text)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.textPrimary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    Text(affirmation.category.displayName)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.textTertiary)
                }
                
                Spacer()
                
                // Favorite button
                Button(action: { onFavorite?() }) {
                    Image(systemName: affirmation.isFavorite ? "heart.fill" : "heart")
                        .font(.system(size: 18))
                        .foregroundColor(affirmation.isFavorite ? .red : .textTertiary)
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.cardDark)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.cardBorder, lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Mini Card (for widget/grid view)

struct MiniAffirmationCard: View {
    let affirmation: Affirmation
    
    private var categoryGradient: [Color] {
        GradientTheme.gradientForCategory(affirmation.category.rawValue)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Category icon
            Image(systemName: affirmation.category.icon)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.white)
                .frame(width: 40, height: 40)
                .background(
                    Circle()
                        .fill(Color.black.opacity(0.2))
                )
            
            Spacer()
            
            Text(affirmation.text)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white)
                .lineLimit(4)
                .multilineTextAlignment(.leading)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        colors: categoryGradient,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        AnimatedBackground(style: .cosmic)
        
        ScrollView {
            VStack(spacing: 20) {
                AffirmationCard(
                    affirmation: Affirmation(
                        text: "I am worthy of love, success, and happiness in all areas of my life.",
                        category: .selfLove
                    )
                )
                .padding(.horizontal)
                
                CompactAffirmationCard(
                    affirmation: Affirmation(
                        text: "Every day I grow stronger and more confident.",
                        category: .confidence
                    )
                )
                .padding(.horizontal)
                
                HStack(spacing: 12) {
                    MiniAffirmationCard(
                        affirmation: Affirmation(
                            text: "I attract abundance",
                            category: .abundance
                        )
                    )
                    
                    MiniAffirmationCard(
                        affirmation: Affirmation(
                            text: "I am at peace",
                            category: .peace
                        )
                    )
                }
                .padding(.horizontal)
                .frame(height: 160)
            }
            .padding(.vertical)
        }
    }
}
