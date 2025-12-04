import SwiftUI

// MARK: - Welcome View (Page 1)

struct WelcomeView: View {
    let onContinue: () -> Void
    @State private var showContent = false
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            // Hero content
            VStack(spacing: 24) {
                // Sun icon with glow
                ZStack {
                    // Outer glow
                    Circle()
                        .fill(Color.glowGold)
                        .frame(width: 150, height: 150)
                        .blur(radius: 60)
                        .opacity(0.5)
                    
                    // Inner glow
                    Circle()
                        .fill(Color.glowGold)
                        .frame(width: 100, height: 100)
                        .blur(radius: 30)
                        .opacity(0.8)
                    
                    // Icon
                    Image(systemName: "sun.max.fill")
                        .font(.system(size: 80))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.glowGold, .glowGoldDark],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .shadow(color: .glowGold.opacity(0.5), radius: 20)
                }
                .scaleEffect(showContent ? 1 : 0.8)
                .opacity(showContent ? 1 : 0)
                
                // Title
                VStack(spacing: 12) {
                    Text("Daily Glow")
                        .font(.system(size: 42, weight: .bold, design: .rounded))
                        .foregroundColor(.textPrimary)
                    
                    Text("Your daily dose of positivity")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.textSecondary)
                }
                .offset(y: showContent ? 0 : 20)
                .opacity(showContent ? 1 : 0)
            }
            
            Spacer()
            
            // Bottom section
            VStack(spacing: 20) {
                // Tagline
                Text("Transform your mindset,\none affirmation at a time")
                    .font(.system(size: 16))
                    .foregroundColor(.textTertiary)
                    .multilineTextAlignment(.center)
                    .opacity(showContent ? 1 : 0)
                
                // CTA
                PrimaryButton(title: "Begin Your Journey", icon: "arrow.right") {
                    onContinue()
                }
                .padding(.horizontal, 20)
                .offset(y: showContent ? 0 : 30)
                .opacity(showContent ? 1 : 0)
            }
            .padding(.bottom, 50)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8).delay(0.2)) {
                showContent = true
            }
        }
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        AnimatedBackground(style: .cosmic)
        WelcomeView(onContinue: {})
    }
}
