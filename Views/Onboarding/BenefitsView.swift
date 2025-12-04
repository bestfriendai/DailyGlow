import SwiftUI

// MARK: - Benefits View (Page 2)

struct BenefitsView: View {
    let onContinue: () -> Void
    @State private var showBenefits = false
    
    private let benefits: [(icon: String, title: String, subtitle: String, color: Color)] = [
        ("brain.head.profile", "Rewire Your Mind", "Transform negative thought patterns into empowering beliefs", .glowPurple),
        ("heart.fill", "Practice Gratitude", "Cultivate appreciation and find joy in everyday moments", .glowCoral),
        ("moon.stars.fill", "Better Sleep", "End your day with peaceful thoughts and calm your mind", .info),
        ("flame.fill", "Build Confidence", "Develop unshakeable self-belief and inner strength", .glowGold)
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            // Header
            VStack(spacing: 12) {
                Text("Why Daily Affirmations?")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.textPrimary)
                
                Text("Science-backed benefits for your mind")
                    .font(.system(size: 16))
                    .foregroundColor(.textSecondary)
            }
            .padding(.bottom, 32)
            
            // Benefits list
            VStack(spacing: 16) {
                ForEach(Array(benefits.enumerated()), id: \.offset) { index, benefit in
                    BenefitCard(
                        icon: benefit.icon,
                        title: benefit.title,
                        subtitle: benefit.subtitle,
                        color: benefit.color
                    )
                    .offset(x: showBenefits ? 0 : -50)
                    .opacity(showBenefits ? 1 : 0)
                    .animation(
                        .spring(response: 0.5, dampingFraction: 0.7)
                        .delay(Double(index) * 0.1),
                        value: showBenefits
                    )
                }
            }
            .padding(.horizontal, 20)
            
            Spacer()
            
            // Badge
            HStack(spacing: 8) {
                Image(systemName: "checkmark.seal.fill")
                    .foregroundColor(.success)
                
                Text("Backed by neuroscience research")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.textTertiary)
            }
            .padding(.bottom, 16)
            
            // CTA
            PrimaryButton(title: "Continue", icon: "arrow.right") {
                onContinue()
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 50)
        }
        .onAppear {
            withAnimation {
                showBenefits = true
            }
        }
    }
}

// MARK: - Benefit Card

struct BenefitCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon
            ZStack {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.system(size: 22))
                    .foregroundColor(color)
            }
            
            // Text
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.textPrimary)
                
                Text(subtitle)
                    .font(.system(size: 14))
                    .foregroundColor(.textTertiary)
                    .lineLimit(2)
            }
            
            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.cardDark)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(color.opacity(0.2), lineWidth: 1)
                )
        )
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        AnimatedBackground(style: .sunrise)
        BenefitsView(onContinue: {})
    }
}
