import SwiftUI

// MARK: - Premium Animated Background
// Dark, atmospheric, dreamcore-inspired backgrounds

struct AnimatedBackground: View {
    @State private var phase: CGFloat = 0
    @State private var glowPhase: CGFloat = 0
    
    var style: BackgroundStyle = .cosmic
    var showParticles: Bool = true
    var showGlow: Bool = true
    
    enum BackgroundStyle {
        case cosmic, aurora, night, sunrise, warm
        
        var colors: [Color] {
            switch self {
            case .cosmic:
                return [
                    Color(red: 0.1, green: 0.06, blue: 0.18),
                    Color(red: 0.05, green: 0.03, blue: 0.1)
                ]
            case .aurora:
                return [
                    Color(red: 0.06, green: 0.1, blue: 0.15),
                    Color(red: 0.03, green: 0.05, blue: 0.1)
                ]
            case .night:
                return [
                    Color(red: 0.04, green: 0.04, blue: 0.1),
                    Color(red: 0.02, green: 0.02, blue: 0.05)
                ]
            case .sunrise:
                return [
                    Color(red: 0.15, green: 0.08, blue: 0.12),
                    Color(red: 0.08, green: 0.05, blue: 0.1)
                ]
            case .warm:
                return [
                    Color(red: 0.12, green: 0.08, blue: 0.06),
                    Color(red: 0.06, green: 0.04, blue: 0.03)
                ]
            }
        }
        
        var accentColor: Color {
            switch self {
            case .cosmic: return Color(red: 0.6, green: 0.3, blue: 0.9)
            case .aurora: return Color(red: 0.3, green: 0.9, blue: 0.7)
            case .night: return Color(red: 0.4, green: 0.5, blue: 0.9)
            case .sunrise: return Color(red: 1.0, green: 0.6, blue: 0.4)
            case .warm: return Color(red: 1.0, green: 0.7, blue: 0.4)
            }
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Base gradient
                LinearGradient(
                    colors: style.colors,
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                // Ambient glow orbs
                if showGlow {
                    // Primary glow
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    style.accentColor.opacity(0.3),
                                    style.accentColor.opacity(0.1),
                                    Color.clear
                                ],
                                center: .center,
                                startRadius: 0,
                                endRadius: geometry.size.width * 0.5
                            )
                        )
                        .frame(width: geometry.size.width * 0.8)
                        .offset(
                            x: geometry.size.width * 0.2 * sin(glowPhase),
                            y: -geometry.size.height * 0.2 + geometry.size.height * 0.1 * cos(glowPhase)
                        )
                        .blur(radius: 60)
                    
                    // Secondary glow
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    Color.glowGold.opacity(0.15),
                                    Color.glowGold.opacity(0.05),
                                    Color.clear
                                ],
                                center: .center,
                                startRadius: 0,
                                endRadius: geometry.size.width * 0.4
                            )
                        )
                        .frame(width: geometry.size.width * 0.6)
                        .offset(
                            x: -geometry.size.width * 0.15 * cos(glowPhase * 0.7),
                            y: geometry.size.height * 0.3 + geometry.size.height * 0.05 * sin(glowPhase * 0.7)
                        )
                        .blur(radius: 40)
                }
                
                // Floating particles
                if showParticles {
                    ForEach(0..<20, id: \.self) { i in
                        Circle()
                            .fill(Color.white.opacity(Double.random(in: 0.1...0.4)))
                            .frame(width: CGFloat.random(in: 1...3))
                            .offset(
                                x: geometry.size.width * CGFloat.random(in: -0.4...0.4),
                                y: geometry.size.height * (0.5 - phase) + CGFloat(i * 40)
                            )
                            .opacity(Double(1 - abs(0.5 - phase) * 2))
                    }
                }
                
                // Subtle noise overlay for texture
                Rectangle()
                    .fill(Color.white.opacity(0.02))
                    .ignoresSafeArea()
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 8).repeatForever(autoreverses: true)) {
                glowPhase = .pi * 2
            }
            withAnimation(.linear(duration: 20).repeatForever(autoreverses: false)) {
                phase = 1
            }
        }
    }
}

// MARK: - Image Background with Overlay

struct ImageBackground: View {
    let imageName: String
    var overlayOpacity: Double = 0.4
    var blurRadius: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Image
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
                    .blur(radius: blurRadius)
                
                // Dark overlay for text readability
                LinearGradient(
                    colors: [
                        Color.black.opacity(overlayOpacity * 0.5),
                        Color.black.opacity(overlayOpacity),
                        Color.black.opacity(overlayOpacity * 0.8)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
        }
        .ignoresSafeArea()
    }
}

// MARK: - Simple Dark Background

struct DarkBackground: View {
    var topColor: Color = Color(red: 0.1, green: 0.08, blue: 0.15)
    var bottomColor: Color = Color(red: 0.05, green: 0.04, blue: 0.08)
    
    var body: some View {
        LinearGradient(
            colors: [topColor, bottomColor],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        AnimatedBackground(style: .cosmic)
        
        VStack {
            Text("Daily Glow")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text("Premium Background")
                .foregroundColor(.white.opacity(0.7))
        }
    }
}
