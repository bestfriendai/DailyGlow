import SwiftUI
import StoreKit

// MARK: - Premium Paywall View
// The money maker - beautiful, persuasive, converts

struct PaywallView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var storeManager = PurchaseManager.shared
    @AppStorage("isPremium") private var isPremium = false
    
    @State private var selectedPlan: PlanType = .yearly
    @State private var isLoading = false
    @State private var showError = false
    @State private var errorMessage = ""
    
    enum PlanType: String, CaseIterable {
        case weekly = "Weekly"
        case monthly = "Monthly"
        case yearly = "Yearly"
        case lifetime = "Lifetime"
        
        var price: String {
            switch self {
            case .weekly: return "$1.99"
            case .monthly: return "$4.99"
            case .yearly: return "$29.99"
            case .lifetime: return "$79.99"
            }
        }
        
        var period: String {
            switch self {
            case .weekly: return "/week"
            case .monthly: return "/month"
            case .yearly: return "/year"
            case .lifetime: return "one-time"
            }
        }
        
        var savings: String? {
            switch self {
            case .yearly: return "SAVE 50%"
            case .lifetime: return "BEST VALUE"
            default: return nil
            }
        }
        
        var description: String {
            switch self {
            case .weekly: return "Billed weekly"
            case .monthly: return "Billed monthly"
            case .yearly: return "Only $2.50/month"
            case .lifetime: return "Pay once, own forever"
            }
        }
        
        var productID: ProductID {
            switch self {
            case .weekly: return .weekly
            case .monthly: return .monthly
            case .yearly: return .yearly
            case .lifetime: return .lifetime
            }
        }
    }
    
    var body: some View {
        ZStack {
            // Background
            AnimatedBackground(style: .cosmic)
            
            ScrollView {
                VStack(spacing: 24) {
                    // Close button
                    HStack {
                        Spacer()
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.textSecondary)
                                .frame(width: 32, height: 32)
                                .background(Circle().fill(Color.white.opacity(0.1)))
                        }
                    }
                    .padding(.top, 16)
                    
                    // Hero section
                    heroSection
                    
                    // Features
                    featuresSection
                    
                    // Pricing plans
                    pricingSection
                    
                    // CTA Button
                    ctaButton
                    
                    // Trust badges
                    trustBadges
                    
                    // Legal text
                    legalText
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
        }
        .alert("Error", isPresented: $showError) {
            Button("OK") {}
        } message: {
            Text(errorMessage)
        }
    }
    
    // MARK: - Hero Section
    
    private var heroSection: some View {
        VStack(spacing: 16) {
            // Crown with glow
            ZStack {
                // Glow
                Circle()
                    .fill(Color.glowGold)
                    .frame(width: 100, height: 100)
                    .blur(radius: 40)
                    .opacity(0.6)
                
                Image(systemName: "crown.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.glowGold, .glowGoldDark],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .shadow(color: .glowGold.opacity(0.5), radius: 20)
            }
            
            Text("Unlock Premium")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.textPrimary)
            
            Text("Transform your mindset with\nunlimited access to everything")
                .font(.system(size: 16))
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
        }
    }
    
    // MARK: - Features Section
    
    private var featuresSection: some View {
        VStack(spacing: 14) {
            FeatureRow(icon: "infinity", title: "Unlimited affirmations", color: .glowPurple)
            FeatureRow(icon: "paintpalette.fill", title: "Beautiful themes & backgrounds", color: .glowCoral)
            FeatureRow(icon: "chart.line.uptrend.xyaxis", title: "Advanced analytics", color: .glowTeal)
            FeatureRow(icon: "bell.badge.fill", title: "Custom reminders", color: .glowGold)
            FeatureRow(icon: "icloud.fill", title: "Cloud sync & backup", color: .info)
            FeatureRow(icon: "nosign", title: "No ads ever", color: .success)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.cardDark)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.cardBorder, lineWidth: 1)
                )
        )
    }
    
    // MARK: - Pricing Section
    
    private var pricingSection: some View {
        VStack(spacing: 12) {
            ForEach(PlanType.allCases, id: \.self) { plan in
                PlanCard(
                    plan: plan,
                    isSelected: selectedPlan == plan
                ) {
                    withAnimation(.spring(response: 0.3)) {
                        selectedPlan = plan
                    }
                    HapticManager.shared.impact(.light)
                }
            }
        }
    }
    
    // MARK: - CTA Button
    
    private var ctaButton: some View {
        VStack(spacing: 12) {
            PrimaryButton(
                title: selectedPlan == .lifetime ? "Get Lifetime Access" : "Start Free Trial",
                icon: selectedPlan == .lifetime ? "crown.fill" : "play.fill",
                isLoading: isLoading
            ) {
                purchase()
            }
            
            if selectedPlan != .lifetime {
                Text("7-day free trial, then \(selectedPlan.price)\(selectedPlan.period)")
                    .font(.system(size: 13))
                    .foregroundColor(.textTertiary)
            }
        }
    }
    
    // MARK: - Trust Badges
    
    private var trustBadges: some View {
        HStack(spacing: 24) {
            PaywallTrustBadge(icon: "lock.shield.fill", text: "Secure")
            PaywallTrustBadge(icon: "arrow.clockwise", text: "Cancel anytime")
            PaywallTrustBadge(icon: "checkmark.seal.fill", text: "Verified")
        }
    }
    
    // MARK: - Legal Text
    
    private var legalText: some View {
        VStack(spacing: 8) {
            Text("By continuing, you agree to our Terms of Service and Privacy Policy. Subscription automatically renews unless cancelled at least 24 hours before the end of the current period.")
                .font(.system(size: 11))
                .foregroundColor(.textMuted)
                .multilineTextAlignment(.center)
            
            Button("Restore Purchases") {
                restorePurchases()
            }
            .font(.system(size: 13, weight: .medium))
            .foregroundColor(.textTertiary)
        }
    }
    
    // MARK: - Actions
    
    private func purchase() {
        isLoading = true
        HapticManager.shared.impact(.medium)
        
        Task {
            do {
                // Use actual StoreKit 2 purchase via PurchaseManager
                try await storeManager.purchase(selectedPlan.productID)
                
                await MainActor.run {
                    isPremium = true
                    isLoading = false
                    SoundManager.shared.playAchievementUnlock()
                    HapticManager.shared.notification(.success)
                    dismiss()
                }
            } catch PurchaseError.purchaseCancelled {
                await MainActor.run {
                    isLoading = false
                    // User cancelled, no error needed
                }
            } catch PurchaseError.purchasePending {
                await MainActor.run {
                    isLoading = false
                    errorMessage = "Your purchase is pending approval."
                    showError = true
                }
            } catch {
                await MainActor.run {
                    isLoading = false
                    errorMessage = error.localizedDescription
                    showError = true
                }
            }
        }
    }
    
    private func restorePurchases() {
        HapticManager.shared.impact(.light)
        isLoading = true
        
        Task {
            do {
                try await storeManager.restorePurchases()
                
                await MainActor.run {
                    isLoading = false
                    if storeManager.isPremium {
                        isPremium = true
                        SoundManager.shared.playSuccess()
                        HapticManager.shared.notification(.success)
                        dismiss()
                    } else {
                        errorMessage = "No previous purchases found."
                        showError = true
                    }
                }
            } catch {
                await MainActor.run {
                    isLoading = false
                    errorMessage = "Failed to restore purchases. Please try again."
                    showError = true
                }
            }
        }
    }
}

// MARK: - Feature Row

struct FeatureRow: View {
    let icon: String
    let title: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(color)
                .frame(width: 28)
            
            Text(title)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.textPrimary)
            
            Spacer()
            
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 18))
                .foregroundColor(.success)
        }
    }
}

// MARK: - Plan Card

struct PlanCard: View {
    let plan: PaywallView.PlanType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                // Radio button
                ZStack {
                    Circle()
                        .stroke(isSelected ? Color.glowGold : Color.cardBorder, lineWidth: 2)
                        .frame(width: 24, height: 24)
                    
                    if isSelected {
                        Circle()
                            .fill(Color.glowGold)
                            .frame(width: 14, height: 14)
                    }
                }
                
                // Plan info
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 8) {
                        Text(plan.rawValue)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.textPrimary)
                        
                        if let savings = plan.savings {
                            Text(savings)
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.black)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 3)
                                .background(
                                    Capsule()
                                        .fill(Color.glowGold)
                                )
                        }
                    }
                    
                    Text(plan.description)
                        .font(.system(size: 13))
                        .foregroundColor(.textTertiary)
                }
                
                Spacer()
                
                // Price
                VStack(alignment: .trailing, spacing: 0) {
                    Text(plan.price)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.textPrimary)
                    
                    Text(plan.period)
                        .font(.system(size: 12))
                        .foregroundColor(.textTertiary)
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? Color.glowGold.opacity(0.1) : Color.cardDark)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(isSelected ? Color.glowGold : Color.cardBorder, lineWidth: isSelected ? 2 : 1)
                    )
            )
        }
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

// MARK: - Paywall Trust Badge

struct PaywallTrustBadge: View {
    let icon: String
    let text: String
    
    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(.textTertiary)
            
            Text(text)
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(.textTertiary)
        }
    }
}

// MARK: - Preview

#Preview {
    PaywallView()
}
