import SwiftUI
import UserNotifications

// MARK: - Notification Setup View (Page 6 - Final)

struct NotificationSetupView: View {
    let onContinue: () -> Void
    @State private var notificationsEnabled = false
    @State private var selectedTime = Date()
    @State private var showTimePicker = false
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            // Hero image
            VStack(spacing: 24) {
                // Phone mockup
                ZStack {
                    // Phone frame
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color(red: 0.1, green: 0.1, blue: 0.15))
                        .frame(width: 200, height: 380)
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color.white.opacity(0.2), lineWidth: 2)
                        )
                    
                    // Screen content
                    VStack(spacing: 0) {
                        // Status bar
                        HStack {
                            Text("9:41")
                                .font(.system(size: 14, weight: .semibold))
                            Spacer()
                            Image(systemName: "wifi")
                            Image(systemName: "battery.100")
                        }
                        .font(.system(size: 12))
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.top, 12)
                        
                        Spacer()
                        
                        // Notification
                        HStack(spacing: 12) {
                            Image(systemName: "sun.max.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.glowGold)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                HStack {
                                    Text("Daily Glow")
                                        .font(.system(size: 13, weight: .semibold))
                                    Spacer()
                                    Text("9:00 AM")
                                        .font(.system(size: 11))
                                        .foregroundColor(.textTertiary)
                                }
                                
                                Text("Your daily affirmation awaits!")
                                    .font(.system(size: 12, weight: .medium))
                                
                                Text("Take a moment for positivity ✨")
                                    .font(.system(size: 11))
                                    .foregroundColor(.textTertiary)
                            }
                        }
                        .padding(12)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.white)
                        )
                        .padding(.horizontal, 16)
                        .offset(y: -80)
                        
                        Spacer()
                    }
                }
                .shadow(color: .black.opacity(0.3), radius: 30, y: 20)
                
                // Text
                VStack(spacing: 12) {
                    Text("Daily Reminders")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.textPrimary)
                    
                    Text("Get gentle nudges to practice your affirmations every day")
                        .font(.system(size: 16))
                        .foregroundColor(.textSecondary)
                        .multilineTextAlignment(.center)
                }
            }
            
            Spacer()
            
            // Toggle section
            VStack(spacing: 16) {
                // Enable toggle
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Enable Notifications")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.textPrimary)
                        
                        Text("We'll send one reminder daily")
                            .font(.system(size: 13))
                            .foregroundColor(.textTertiary)
                    }
                    
                    Spacer()
                    
                    Toggle("", isOn: $notificationsEnabled)
                        .tint(.glowGold)
                        .labelsHidden()
                        .onChange(of: notificationsEnabled) { newValue in
                            if newValue {
                                requestNotificationPermission()
                            }
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
                
                // Time picker (shown when enabled)
                if notificationsEnabled {
                    HStack {
                        Text("Reminder time")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.textPrimary)
                        
                        Spacer()
                        
                        DatePicker(
                            "",
                            selection: $selectedTime,
                            displayedComponents: .hourAndMinute
                        )
                        .labelsHidden()
                        .colorScheme(.dark)
                        .tint(.glowGold)
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
                    .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }
            .padding(.horizontal, 20)
            .animation(.spring(response: 0.3), value: notificationsEnabled)
            
            // CTA
            VStack(spacing: 12) {
                PrimaryButton(title: "Get Started", icon: "sparkles") {
                    if notificationsEnabled {
                        scheduleNotification()
                    }
                    onContinue()
                }
                
                if !notificationsEnabled {
                    GhostButton(title: "Skip for now") {
                        onContinue()
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 24)
            .padding(.bottom, 50)
        }
    }
    
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            DispatchQueue.main.async {
                if !granted {
                    notificationsEnabled = false
                }
            }
        }
    }
    
    private func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Daily Glow ✨"
        content.body = "Your daily affirmation awaits! Take a moment for positivity."
        content.sound = .default
        
        let components = Calendar.current.dateComponents([.hour, .minute], from: selectedTime)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        
        let request = UNNotificationRequest(
            identifier: "daily-affirmation",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request)
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        AnimatedBackground(style: .night)
        NotificationSetupView(onContinue: {})
    }
}
