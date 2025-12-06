//
//  WidgetViews.swift
//  DailyGlow
//
//  Widget views for home screen widgets
//  NOTE: Requires Widget Extension Target in Xcode to function
//

import SwiftUI
import WidgetKit

// MARK: - Widget Entry
struct AffirmationEntry: TimelineEntry {
    let date: Date
    let affirmation: String
    let category: String
    let userName: String
    let streakCount: Int
}

// MARK: - Small Widget View
struct SmallWidgetView: View {
    let entry: AffirmationEntry
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [
                    Color(red: 0.1, green: 0.06, blue: 0.18),
                    Color(red: 0.05, green: 0.03, blue: 0.1)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            VStack(alignment: .leading, spacing: 8) {
                // Header with streak
                HStack {
                    Image(systemName: "sun.max.fill")
                        .font(.system(size: 14))
                        .foregroundColor(Color(red: 1.0, green: 0.78, blue: 0.35))
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Image(systemName: "flame.fill")
                            .font(.system(size: 12))
                            .foregroundColor(.orange)
                        Text("\(entry.streakCount)")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                
                Spacer()
                
                // Affirmation text
                Text(entry.affirmation)
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                    .lineLimit(4)
                    .minimumScaleFactor(0.8)
            }
            .padding(12)
        }
    }
}

// MARK: - Medium Widget View
struct MediumWidgetView: View {
    let entry: AffirmationEntry
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [
                    Color(red: 0.1, green: 0.06, blue: 0.18),
                    Color(red: 0.05, green: 0.03, blue: 0.1)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            HStack(spacing: 16) {
                // Left side - Icon and streak
                VStack(spacing: 8) {
                    ZStack {
                        Circle()
                            .fill(Color(red: 1.0, green: 0.78, blue: 0.35).opacity(0.2))
                            .frame(width: 50, height: 50)
                        
                        Image(systemName: "sun.max.fill")
                            .font(.system(size: 24))
                            .foregroundColor(Color(red: 1.0, green: 0.78, blue: 0.35))
                    }
                    
                    HStack(spacing: 4) {
                        Image(systemName: "flame.fill")
                            .font(.system(size: 14))
                            .foregroundColor(.orange)
                        Text("\(entry.streakCount)")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                
                // Right side - Content
                VStack(alignment: .leading, spacing: 6) {
                    if !entry.userName.isEmpty {
                        Text("Hi, \(entry.userName)")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.white.opacity(0.7))
                    }
                    
                    Text(entry.affirmation)
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                        .lineLimit(3)
                        .minimumScaleFactor(0.8)
                    
                    Spacer()
                    
                    Text(entry.category)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.white.opacity(0.6))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(Color.white.opacity(0.1))
                        )
                }
                
                Spacer()
            }
            .padding(16)
        }
    }
}

// MARK: - Large Widget View
struct LargeWidgetView: View {
    let entry: AffirmationEntry
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [
                    Color(red: 0.1, green: 0.06, blue: 0.18),
                    Color(red: 0.05, green: 0.03, blue: 0.1)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            VStack(spacing: 16) {
                // Header
                HStack {
                    HStack(spacing: 8) {
                        Image(systemName: "sun.max.fill")
                            .font(.system(size: 20))
                            .foregroundColor(Color(red: 1.0, green: 0.78, blue: 0.35))
                        
                        Text("Daily Glow")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Image(systemName: "flame.fill")
                            .font(.system(size: 16))
                            .foregroundColor(.orange)
                        Text("\(entry.streakCount) day streak")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(Color.white.opacity(0.1))
                    )
                }
                
                Spacer()
                
                // Affirmation card
                VStack(spacing: 12) {
                    Text(entry.affirmation)
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .lineLimit(4)
                    
                    Text(entry.category)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(Color.white.opacity(0.1))
                        )
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white.opacity(0.08))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.white.opacity(0.15), lineWidth: 1)
                        )
                )
                
                Spacer()
                
                // Greeting
                if !entry.userName.isEmpty {
                    Text("Keep glowing, \(entry.userName) ✨")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.6))
                }
            }
            .padding(20)
        }
    }
}

// MARK: - Widget Provider
struct DailyGlowWidgetProvider: TimelineProvider {
    
    func placeholder(in context: Context) -> AffirmationEntry {
        AffirmationEntry(
            date: Date(),
            affirmation: "I am worthy of love and happiness",
            category: "Self Love",
            userName: "",
            streakCount: 1
        )
    }
    
    func getSnapshot(in context: Context, completion: @escaping (AffirmationEntry) -> Void) {
        let entry = createEntry()
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<AffirmationEntry>) -> Void) {
        let entry = createEntry()
        
        // Update at midnight for new daily affirmation
        let midnight = Calendar.current.startOfDay(for: Date().addingTimeInterval(86400))
        let timeline = Timeline(entries: [entry], policy: .after(midnight))
        
        completion(timeline)
    }
    
    private func createEntry() -> AffirmationEntry {
        // Get data from shared UserDefaults (App Group)
        let defaults = UserDefaults(suiteName: "group.dailyglow") ?? UserDefaults.standard
        
        let affirmation = defaults.string(forKey: "widgetAffirmation") ?? "I am worthy of love and happiness"
        let category = defaults.string(forKey: "widgetCategory") ?? "Self Love"
        let userName = defaults.string(forKey: "userName") ?? ""
        let streakCount = defaults.integer(forKey: "currentStreak")
        
        return AffirmationEntry(
            date: Date(),
            affirmation: affirmation,
            category: category,
            userName: userName,
            streakCount: max(1, streakCount)
        )
    }
}

// MARK: - Widget Configuration
// Note: This struct should be in the Widget Extension target
/*
@main
struct DailyGlowWidget: Widget {
    let kind: String = "DailyGlowWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: DailyGlowWidgetProvider()) { entry in
            DailyGlowWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Daily Glow")
        .description("Your daily affirmation at a glance")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

struct DailyGlowWidgetEntryView: View {
    @Environment(\.widgetFamily) var family
    let entry: AffirmationEntry
    
    var body: some View {
        switch family {
        case .systemSmall:
            SmallWidgetView(entry: entry)
        case .systemMedium:
            MediumWidgetView(entry: entry)
        case .systemLarge:
            LargeWidgetView(entry: entry)
        default:
            SmallWidgetView(entry: entry)
        }
    }
}
*/

// MARK: - Preview
#Preview("Small Widget", as: .systemSmall) {
    // This preview only works when running in Widget Extension
    SmallWidgetView(entry: AffirmationEntry(
        date: Date(),
        affirmation: "I am worthy of love",
        category: "Self Love",
        userName: "Sarah",
        streakCount: 7
    ))
}
