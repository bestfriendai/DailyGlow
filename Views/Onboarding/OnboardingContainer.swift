import SwiftUI

// MARK: - Onboarding Container
// Beautiful, premium onboarding flow

struct OnboardingContainer: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var currentPage = 0
    
    private let totalPages = 6
    
    var body: some View {
        ZStack {
            // Background
            AnimatedBackground(style: backgroundStyle)
            
            VStack(spacing: 0) {
                // Progress bar
                progressBar
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                
                // Content
                TabView(selection: $currentPage) {
                    WelcomeView(onContinue: nextPage)
                        .tag(0)
                    
                    BenefitsView(onContinue: nextPage)
                        .tag(1)
                    
                    NameInputView(onContinue: nextPage)
                        .tag(2)
                    
                    MoodSelectorView(onContinue: nextPage)
                        .tag(3)
                    
                    CategoryPickerView(onContinue: nextPage)
                        .tag(4)
                    
                    NotificationSetupView(onContinue: completeOnboarding)
                        .tag(5)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeInOut(duration: 0.3), value: currentPage)
            }
        }
    }
    
    private var backgroundStyle: AnimatedBackground.BackgroundStyle {
        switch currentPage {
        case 0: return .cosmic
        case 1: return .sunrise
        case 2: return .aurora
        case 3: return .warm
        case 4: return .cosmic
        case 5: return .night
        default: return .cosmic
        }
    }
    
    private var progressBar: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background
                Capsule()
                    .fill(Color.white.opacity(0.1))
                    .frame(height: 4)
                
                // Progress
                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [.glowGold, .glowGoldDark],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: geometry.size.width * CGFloat(currentPage + 1) / CGFloat(totalPages), height: 4)
                    .animation(.spring(response: 0.4), value: currentPage)
            }
        }
        .frame(height: 4)
    }
    
    private func nextPage() {
        withAnimation {
            currentPage += 1
        }
        HapticManager.shared.impact(.light)
    }
    
    private func completeOnboarding() {
        HapticManager.shared.notification(.success)
        SoundManager.shared.playSuccess()
        hasCompletedOnboarding = true
    }
}

// MARK: - Preview

#Preview {
    OnboardingContainer()
}
