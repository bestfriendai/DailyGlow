//
//  DailyGlowApp.swift
//  DailyGlow
//
//  Premium affirmation app - your daily dose of positivity ✨
//

import SwiftUI
import UserNotifications

@main
struct DailyGlowApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var affirmationService = AffirmationService.shared
    
    init() {
        // Setup appearance on launch
        setupAppearance()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(affirmationService)
                .preferredColorScheme(.dark) // Always dark mode for premium feel
                .onAppear {
                    updateStreak()
                }
        }
    }
    
    private func setupAppearance() {
        // Navigation bar
        let navAppearance = UINavigationBarAppearance()
        navAppearance.configureWithTransparentBackground()
        navAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().standardAppearance = navAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navAppearance
        
        // Tab bar (hidden - using custom)
        UITabBar.appearance().isHidden = true
        
        // Text fields
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [
            .foregroundColor: UIColor.white
        ]
    }
    
    private func updateStreak() {
        // Update streak based on last open date
        let defaults = UserDefaults.standard
        let lastOpenDate = defaults.object(forKey: "lastOpenDate") as? Date ?? Date.distantPast
        let calendar = Calendar.current
        
        if calendar.isDateInToday(lastOpenDate) {
            // Already opened today, no change
        } else if calendar.isDateInYesterday(lastOpenDate) {
            // Streak continues
            let currentStreak = defaults.integer(forKey: "currentStreak")
            defaults.set(currentStreak + 1, forKey: "currentStreak")
            
            // Check for streak milestones
            let newStreak = currentStreak + 1
            if [7, 30, 100, 365].contains(newStreak) {
                SoundManager.shared.playStreakMilestone()
                HapticManager.shared.playStreak()
            }
        } else {
            // Streak broken, reset to 1
            defaults.set(1, forKey: "currentStreak")
        }
        
        // Update last open date
        defaults.set(Date(), forKey: "lastOpenDate")
    }
}

// MARK: - App Delegate

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Notification delegate
        UNUserNotificationCenter.current().delegate = self
        
        // Setup app shortcuts
        setupAppShortcuts()
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Clear badge
        application.applicationIconBadgeNumber = 0
    }
    
    // MARK: - Notifications
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // Handle notification tap
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Show even when foreground
        completionHandler([.banner, .sound])
    }
    
    // MARK: - App Shortcuts
    
    private func setupAppShortcuts() {
        UIApplication.shared.shortcutItems = [
            UIApplicationShortcutItem(
                type: "com.dailyglow.today",
                localizedTitle: "Today's Affirmation",
                localizedSubtitle: nil,
                icon: UIApplicationShortcutIcon(systemImageName: "sun.max.fill")
            ),
            UIApplicationShortcutItem(
                type: "com.dailyglow.journal",
                localizedTitle: "Journal",
                localizedSubtitle: nil,
                icon: UIApplicationShortcutIcon(systemImageName: "book.fill")
            ),
            UIApplicationShortcutItem(
                type: "com.dailyglow.favorites",
                localizedTitle: "Favorites",
                localizedSubtitle: nil,
                icon: UIApplicationShortcutIcon(systemImageName: "heart.fill")
            )
        ]
    }
}
