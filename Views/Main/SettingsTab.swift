import SwiftUI

// MARK: - Settings Tab

struct SettingsTab: View {
    @AppStorage("userName") private var userName = ""
    @AppStorage("isPremium") private var isPremium = false
    @AppStorage("soundEnabled") private var soundEnabled = true
    @AppStorage("hapticsEnabled") private var hapticsEnabled = true
    @AppStorage("notificationsEnabled") private var notificationsEnabled = true
    @AppStorage("currentStreak") private var currentStreak = 1
    
    @State private var showPaywall = false
    @State private var showAchievements = false
    @State private var showPrivacyPolicy = false
    @State private var showTerms = false
    
    var body: some View {
        ZStack {
            // Background
            DarkBackground()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    headerView
                    
                    // Premium card (if not premium)
                    if !isPremium {
                        premiumCard
                    }
                    
                    // Profile section
                    settingsSection(title: "Profile") {
                        SettingsRow(
                            icon: "person.fill",
                            iconColor: .glowPurple,
                            title: "Name",
                            subtitle: userName.isEmpty ? "Set your name" : userName
                        ) {
                            // Edit name
                        }
                        
                        SettingsRow(
                            icon: "trophy.fill",
                            iconColor: .glowGold,
                            title: "Achievements",
                            subtitle: "View your progress"
                        ) {
                            showAchievements = true
                        }
                    }
                    
                    // Preferences section
                    settingsSection(title: "Preferences") {
                        SettingsToggleRow(
                            icon: "speaker.wave.2.fill",
                            iconColor: .glowTeal,
                            title: "Sound Effects",
                            isOn: $soundEnabled
                        )
                        
                        SettingsToggleRow(
                            icon: "hand.tap.fill",
                            iconColor: .glowCoral,
                            title: "Haptic Feedback",
                            isOn: $hapticsEnabled
                        )
                        
                        SettingsToggleRow(
                            icon: "bell.fill",
                            iconColor: .glowGold,
                            title: "Daily Reminders",
                            isOn: $notificationsEnabled
                        )
                    }
                    
                    // Subscription section
                    settingsSection(title: "Subscription") {
                        if isPremium {
                            SettingsRow(
                                icon: "crown.fill",
                                iconColor: .glowGold,
                                title: "Premium Active",
                                subtitle: "Lifetime access"
                            ) {}
                        }
                        
                        SettingsRow(
                            icon: "arrow.clockwise",
                            iconColor: .glowPurple,
                            title: "Restore Purchases",
                            subtitle: "Recover your subscription"
                        ) {
                            restorePurchases()
                        }
                    }
                    
                    // Legal section
                    settingsSection(title: "Legal") {
                        SettingsRow(
                            icon: "lock.shield.fill",
                            iconColor: .info,
                            title: "Privacy Policy",
                            subtitle: nil
                        ) {
                            showPrivacyPolicy = true
                        }
                        
                        SettingsRow(
                            icon: "doc.text.fill",
                            iconColor: .info,
                            title: "Terms of Service",
                            subtitle: nil
                        ) {
                            showTerms = true
                        }
                    }
                    
                    // App info
                    appInfo
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 120)
            }
        }
        .sheet(isPresented: $showPaywall) {
            PaywallView()
        }
        .sheet(isPresented: $showAchievements) {
            AchievementsView()
        }
        .sheet(isPresented: $showPrivacyPolicy) {
            PrivacyPolicyView()
        }
        .sheet(isPresented: $showTerms) {
            TermsOfServiceView()
        }
    }
    
    // MARK: - Header
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Settings")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.textPrimary)
                
                if isPremium {
                    HStack(spacing: 6) {
                        Image(systemName: "crown.fill")
                            .font(.system(size: 12))
                        Text("Premium")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .foregroundColor(.glowGold)
                }
            }
            
            Spacer()
            
            Image(systemName: "gearshape.fill")
                .font(.system(size: 28))
                .foregroundColor(.textTertiary)
        }
        .padding(.top, 16)
    }
    
    // MARK: - Premium Card
    
    private var premiumCard: some View {
        Button {
            showPaywall = true
        } label: {
            HStack(spacing: 16) {
                // Crown icon with glow
                ZStack {
                    Circle()
                        .fill(Color.glowGold)
                        .frame(width: 50, height: 50)
                        .blur(radius: 15)
                        .opacity(0.5)
                    
                    Image(systemName: "crown.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.glowGold)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Unlock Premium")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.textPrimary)
                    
                    Text("Unlimited affirmations & more")
                        .font(.system(size: 14))
                        .foregroundColor(.textSecondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.textTertiary)
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            colors: [Color.glowGold.opacity(0.15), Color.glowGold.opacity(0.05)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.glowGold.opacity(0.3), lineWidth: 1)
                    )
            )
        }
    }
    
    // MARK: - Settings Section
    
    private func settingsSection<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title.uppercased())
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.textTertiary)
                .padding(.leading, 4)
            
            VStack(spacing: 2) {
                content()
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.cardDark)
            )
        }
    }
    
    // MARK: - App Info
    
    private var appInfo: some View {
        VStack(spacing: 8) {
            Image(systemName: "sun.max.fill")
                .font(.system(size: 32))
                .foregroundColor(.glowGold)
            
            Text("Daily Glow")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.textPrimary)
            
            Text("Version 1.0.0")
                .font(.system(size: 12))
                .foregroundColor(.textTertiary)
            
            Text("Made with ❤️")
                .font(.system(size: 12))
                .foregroundColor(.textTertiary)
        }
        .padding(.top, 20)
    }
    
    // MARK: - Actions
    
    private func restorePurchases() {
        // Restore purchases logic
        HapticManager.shared.impact(.medium)
    }
}

// MARK: - Settings Row

struct SettingsRow: View {
    let icon: String
    var iconColor: Color = .textPrimary
    let title: String
    var subtitle: String? = nil
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                // Icon
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(iconColor)
                    .frame(width: 32)
                
                // Text
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.textPrimary)
                    
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(.system(size: 13))
                            .foregroundColor(.textTertiary)
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.textTertiary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
        }
    }
}

// MARK: - Settings Toggle Row

struct SettingsToggleRow: View {
    let icon: String
    var iconColor: Color = .textPrimary
    let title: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack(spacing: 14) {
            // Icon
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(iconColor)
                .frame(width: 32)
            
            // Title
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.textPrimary)
            
            Spacer()
            
            // Toggle
            Toggle("", isOn: $isOn)
                .tint(.glowGold)
                .labelsHidden()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

// MARK: - Safari View

import SafariServices

struct SafariView: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        SFSafariViewController(url: url)
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}

// MARK: - Preview

#Preview {
    SettingsTab()
}
