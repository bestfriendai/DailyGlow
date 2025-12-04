//
//  MonetizationManager.swift
//  DailyGlow
//
//  Strategic paywall triggers and App Store review prompts
//  THE MONEY ENGINE! 💰🚀🛥️
//

import SwiftUI
import StoreKit

@MainActor
class MonetizationManager: ObservableObject {
    
    // MARK: - Singleton
    static let shared = MonetizationManager()
    
    // MARK: - Published Properties
    @Published var shouldShowPaywall = false
    @Published var paywallTrigger: PaywallTrigger = .general
    
    // MARK: - UserDefaults Keys
    private let freeAffirmationsViewedKey = "freeAffirmationsViewed"
    private let freeAffirmationLimitKey = "freeAffirmationLimit"
    private let lastPaywallShownKey = "lastPaywallShown"
    private let paywallShownCountKey = "paywallShownCount"
    private let hasRequestedReviewKey = "hasRequestedReview"
    private let positiveActionsCountKey = "positiveActionsCount"
    private let appOpenCountKey = "appOpenCount"
    private let journalEntriesCountKey = "journalEntriesCount"
    
    // MARK: - Configuration
    private let freeAffirmationLimit = 5  // Free users get 5 per day
    private let paywallCooldownHours = 4  // Don't show paywall more than every 4 hours
    private let reviewPromptThreshold = 10 // Ask for review after 10 positive actions
    
    // MARK: - Paywall Triggers
    enum PaywallTrigger: String {
        case general = "General"
        case affirmationLimit = "Daily Limit Reached"
        case premiumCategory = "Premium Category"
        case journalAnalytics = "Journal Analytics"
        case customTheme = "Custom Theme"
        case widget = "Widget Access"
        case streak = "Streak Celebration"
        case onboarding = "Onboarding"
        
        var headline: String {
            switch self {
            case .general:
                return "Unlock Your Full Potential"
            case .affirmationLimit:
                return "You've Used Your Daily Affirmations!"
            case .premiumCategory:
                return "This is a Premium Category"
            case .journalAnalytics:
                return "Unlock Deep Insights"
            case .customTheme:
                return "Express Your Unique Style"
            case .widget:
                return "Affirmations on Your Home Screen"
            case .streak:
                return "Keep Your Momentum Going!"
            case .onboarding:
                return "Start Your Journey Right"
            }
        }
        
        var subtitle: String {
            switch self {
            case .general:
                return "Get unlimited access to 1000+ affirmations"
            case .affirmationLimit:
                return "Upgrade for unlimited daily affirmations"
            case .premiumCategory:
                return "Access exclusive affirmation collections"
            case .journalAnalytics:
                return "See your mood patterns and growth over time"
            case .customTheme:
                return "Beautiful premium themes await you"
            case .widget:
                return "Daily inspiration right on your home screen"
            case .streak:
                return "Premium members never lose their streaks"
            case .onboarding:
                return "Get the most out of Daily Glow"
            }
        }
    }
    
    // MARK: - Initialization
    private init() {
        setupNotifications()
        incrementAppOpenCount()
    }
    
    // MARK: - Check Free Limit
    func canViewFreeAffirmation() -> Bool {
        // Premium users have unlimited access
        if PurchaseManager.shared.isPremium {
            return true
        }
        
        let viewedToday = getTodayViewCount()
        return viewedToday < freeAffirmationLimit
    }
    
    func recordAffirmationView() {
        guard !PurchaseManager.shared.isPremium else { return }
        
        var viewedToday = getTodayViewCount()
        viewedToday += 1
        
        let today = Calendar.current.startOfDay(for: Date())
        UserDefaults.standard.set(viewedToday, forKey: "\(freeAffirmationsViewedKey)_\(today.timeIntervalSince1970)")
        
        // Check if limit reached
        if viewedToday >= freeAffirmationLimit {
            triggerPaywall(reason: .affirmationLimit)
        }
    }
    
    private func getTodayViewCount() -> Int {
        let today = Calendar.current.startOfDay(for: Date())
        return UserDefaults.standard.integer(forKey: "\(freeAffirmationsViewedKey)_\(today.timeIntervalSince1970)")
    }
    
    func remainingFreeAffirmations() -> Int {
        if PurchaseManager.shared.isPremium {
            return .max
        }
        return max(0, freeAffirmationLimit - getTodayViewCount())
    }
    
    // MARK: - Paywall Triggers
    func triggerPaywall(reason: PaywallTrigger) {
        // Don't show if premium
        guard !PurchaseManager.shared.isPremium else { return }
        
        // Check cooldown
        if let lastShown = UserDefaults.standard.object(forKey: lastPaywallShownKey) as? Date {
            let hoursSinceLastShown = Date().timeIntervalSince(lastShown) / 3600
            if hoursSinceLastShown < Double(paywallCooldownHours) && reason != .affirmationLimit {
                return
            }
        }
        
        // Update state
        paywallTrigger = reason
        shouldShowPaywall = true
        
        // Record
        UserDefaults.standard.set(Date(), forKey: lastPaywallShownKey)
        let count = UserDefaults.standard.integer(forKey: paywallShownCountKey)
        UserDefaults.standard.set(count + 1, forKey: paywallShownCountKey)
        
        // Haptic
        HapticManager.shared.impact(.medium)
    }
    
    func checkPremiumFeatureAccess(feature: PaywallTrigger) -> Bool {
        if PurchaseManager.shared.isPremium {
            return true
        }
        triggerPaywall(reason: feature)
        return false
    }
    
    // MARK: - Strategic Trigger Points
    
    /// Call after viewing 3rd affirmation in a session
    func checkSessionPaywallTrigger(affirmationsViewed: Int) {
        guard !PurchaseManager.shared.isPremium else { return }
        
        // Show paywall after viewing 3 affirmations in first session
        let appOpens = UserDefaults.standard.integer(forKey: appOpenCountKey)
        if appOpens <= 2 && affirmationsViewed == 3 {
            triggerPaywall(reason: .general)
        }
        
        // Show paywall after every 10 affirmations for returning free users
        if affirmationsViewed > 0 && affirmationsViewed % 10 == 0 {
            triggerPaywall(reason: .affirmationLimit)
        }
    }
    
    /// Call when user tries to access journal analytics
    func checkAnalyticsAccess() -> Bool {
        return checkPremiumFeatureAccess(feature: .journalAnalytics)
    }
    
    /// Call when user tries to change theme
    func checkThemeAccess() -> Bool {
        return checkPremiumFeatureAccess(feature: .customTheme)
    }
    
    /// Call when user reaches streak milestone
    func celebrateStreak(days: Int) {
        if days == 3 || days == 7 || days == 14 {
            if !PurchaseManager.shared.isPremium {
                // Delay slightly to let the celebration show first
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.triggerPaywall(reason: .streak)
                }
            }
        }
    }
    
    // MARK: - App Store Review
    func recordPositiveAction() {
        var count = UserDefaults.standard.integer(forKey: positiveActionsCountKey)
        count += 1
        UserDefaults.standard.set(count, forKey: positiveActionsCountKey)
        
        // Check if we should ask for review
        checkReviewPrompt()
    }
    
    func checkReviewPrompt() {
        let hasRequested = UserDefaults.standard.bool(forKey: hasRequestedReviewKey)
        let positiveActions = UserDefaults.standard.integer(forKey: positiveActionsCountKey)
        
        // Only ask once, after threshold positive actions
        if !hasRequested && positiveActions >= reviewPromptThreshold {
            requestReview()
        }
    }
    
    func requestReview() {
        // Mark as requested
        UserDefaults.standard.set(true, forKey: hasRequestedReviewKey)
        
        // Request review
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
    
    /// Call this at key positive moments
    func trackPositiveMoment(_ moment: PositiveMoment) {
        switch moment {
        case .favoriteAdded:
            recordPositiveAction()
        case .journalEntryCreated:
            recordPositiveAction()
            recordPositiveAction() // Double weight
        case .streakAchieved(let days):
            if days >= 3 {
                recordPositiveAction()
                recordPositiveAction()
                recordPositiveAction() // Triple weight for streaks
            }
        case .achievementUnlocked:
            recordPositiveAction()
            recordPositiveAction()
        case .shareCompleted:
            recordPositiveAction()
        case .onboardingCompleted:
            recordPositiveAction()
        }
    }
    
    enum PositiveMoment {
        case favoriteAdded
        case journalEntryCreated
        case streakAchieved(days: Int)
        case achievementUnlocked
        case shareCompleted
        case onboardingCompleted
    }
    
    // MARK: - App Open Tracking
    private func incrementAppOpenCount() {
        let count = UserDefaults.standard.integer(forKey: appOpenCountKey)
        UserDefaults.standard.set(count + 1, forKey: appOpenCountKey)
    }
    
    // MARK: - Notifications
    private func setupNotifications() {
        // Listen for premium status changes
        NotificationCenter.default.addObserver(
            forName: Notification.Name("PremiumStatusChanged"),
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.shouldShowPaywall = false
        }
    }
}

// MARK: - Paywall View Modifier
struct PaywallModifier: ViewModifier {
    @ObservedObject var monetization = MonetizationManager.shared
    
    func body(content: Content) -> some View {
        content
            .sheet(isPresented: $monetization.shouldShowPaywall) {
                PaywallView()
            }
    }
}

extension View {
    func withPaywall() -> some View {
        modifier(PaywallModifier())
    }
}

// MARK: - Premium Gate View
struct PremiumGate<Content: View>: View {
    let feature: MonetizationManager.PaywallTrigger
    let content: () -> Content
    
    @ObservedObject private var purchaseManager = PurchaseManager.shared
    @State private var showPaywall = false
    
    var body: some View {
        Group {
            if purchaseManager.isPremium {
                content()
            } else {
                lockedView
            }
        }
        .sheet(isPresented: $showPaywall) {
            PaywallView()
        }
    }
    
    private var lockedView: some View {
        VStack(spacing: 20) {
            Image(systemName: "lock.fill")
                .font(.system(size: 50))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.orange, .pink],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            Text(feature.headline)
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            Text(feature.subtitle)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button {
                showPaywall = true
                HapticManager.shared.impact(.medium)
            } label: {
                Text("Unlock Premium")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        LinearGradient(
                            colors: [.orange, .pink],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(14)
            }
            .padding(.horizontal, 40)
        }
        .padding()
    }
}

// MARK: - Free Affirmation Counter
struct FreeAffirmationCounter: View {
    @ObservedObject private var monetization = MonetizationManager.shared
    @ObservedObject private var purchaseManager = PurchaseManager.shared
    
    var body: some View {
        if !purchaseManager.isPremium {
            HStack(spacing: 6) {
                Image(systemName: "sparkles")
                    .font(.caption)
                
                Text("\(monetization.remainingFreeAffirmations()) free today")
                    .font(.caption)
                    .fontWeight(.medium)
            }
            .foregroundColor(.white.opacity(0.8))
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(.ultraThinMaterial)
            )
        }
    }
}

