import SwiftUI

// MARK: - Premium Glassmorphic Card
// Beautiful frosted glass effect with glow

struct GlassmorphicCard<Content: View>: View {
    let content: Content
    var cornerRadius: CGFloat = 24
    var padding: CGFloat = 20
    var glowColor: Color = .glowPurple
    var showGlow: Bool = false
    var backgroundOpacity: Double = 0.1
    
    init(
        cornerRadius: CGFloat = 24,
        padding: CGFloat = 20,
        glowColor: Color = .glowPurple,
        showGlow: Bool = false,
        backgroundOpacity: Double = 0.1,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.cornerRadius = cornerRadius
        self.padding = padding
        self.glowColor = glowColor
        self.showGlow = showGlow
        self.backgroundOpacity = backgroundOpacity
    }
    
    var body: some View {
        content
            .padding(padding)
            .background(
                ZStack {
                    // Glow effect
                    if showGlow {
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .fill(glowColor.opacity(0.3))
                            .blur(radius: 20)
                            .offset(y: 5)
                    }
                    
                    // Glass background
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(Color.white.opacity(backgroundOpacity))
                        .background(
                            RoundedRectangle(cornerRadius: cornerRadius)
                                .fill(.ultraThinMaterial)
                                .opacity(0.5)
                        )
                    
                    // Border
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.25),
                                    Color.white.opacity(0.1),
                                    Color.white.opacity(0.05)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                }
            )
    }
}

// MARK: - Solid Card Variant

struct SolidCard<Content: View>: View {
    let content: Content
    var cornerRadius: CGFloat = 20
    var padding: CGFloat = 16
    var backgroundColor: Color = .cardDark
    
    init(
        cornerRadius: CGFloat = 20,
        padding: CGFloat = 16,
        backgroundColor: Color = .cardDark,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.cornerRadius = cornerRadius
        self.padding = padding
        self.backgroundColor = backgroundColor
    }
    
    var body: some View {
        content
            .padding(padding)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(backgroundColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(Color.cardBorder, lineWidth: 1)
                    )
            )
    }
}

// MARK: - Gradient Card

struct GradientCard<Content: View>: View {
    let content: Content
    var colors: [Color]
    var cornerRadius: CGFloat = 24
    var padding: CGFloat = 20
    
    init(
        colors: [Color] = [Color.glowPurple, Color.glowPurpleDark],
        cornerRadius: CGFloat = 24,
        padding: CGFloat = 20,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.colors = colors
        self.cornerRadius = cornerRadius
        self.padding = padding
    }
    
    var body: some View {
        content
            .padding(padding)
            .background(
                ZStack {
                    // Shadow/glow
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(
                            LinearGradient(
                                colors: colors,
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .blur(radius: 15)
                        .opacity(0.5)
                        .offset(y: 8)
                    
                    // Main gradient
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(
                            LinearGradient(
                                colors: colors,
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    // Highlight
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.4),
                                    Color.white.opacity(0.1),
                                    Color.clear
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                }
            )
    }
}

// MARK: - Interactive Card (for selection states)

struct SelectableCard<Content: View>: View {
    let content: Content
    let isSelected: Bool
    var selectedColor: Color = .glowGold
    var cornerRadius: CGFloat = 16
    var padding: CGFloat = 16
    
    init(
        isSelected: Bool,
        selectedColor: Color = .glowGold,
        cornerRadius: CGFloat = 16,
        padding: CGFloat = 16,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.isSelected = isSelected
        self.selectedColor = selectedColor
        self.cornerRadius = cornerRadius
        self.padding = padding
    }
    
    var body: some View {
        content
            .padding(padding)
            .background(
                ZStack {
                    if isSelected {
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .fill(selectedColor.opacity(0.15))
                        
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(selectedColor, lineWidth: 2)
                    } else {
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .fill(Color.cardDark)
                        
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(Color.cardBorder, lineWidth: 1)
                    }
                }
            )
            .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        AnimatedBackground(style: .cosmic)
        
        VStack(spacing: 20) {
            GlassmorphicCard {
                Text("Glassmorphic Card")
                    .foregroundColor(.white)
            }
            
            SolidCard {
                Text("Solid Card")
                    .foregroundColor(.white)
            }
            
            GradientCard(colors: [.glowGold, .glowGoldDark]) {
                Text("Gradient Card")
                    .foregroundColor(.white)
                    .fontWeight(.semibold)
            }
            
            SelectableCard(isSelected: true) {
                Text("Selected Card")
                    .foregroundColor(.white)
            }
        }
        .padding()
    }
}
