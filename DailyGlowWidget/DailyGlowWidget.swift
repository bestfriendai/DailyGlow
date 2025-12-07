import WidgetKit
import SwiftUI

// MARK: - Widget Entry
struct DailyGlowEntry: TimelineEntry {
    let date: Date
    let affirmation: String
    let category: String
    let streak: Int
}

// MARK: - Timeline Provider
struct DailyGlowProvider: TimelineProvider {
    
    // Sample affirmations for the widget
    private let affirmations = [
        ("I am worthy of love and happiness", "Self-Love"),
        ("Today I choose joy and gratitude", "Gratitude"),
        ("I am capable of achieving my goals", "Success"),
        ("I radiate confidence and positivity", "Confidence"),
        ("I am at peace with who I am", "Inner Peace"),
        ("Every day I grow stronger", "Growth"),
        ("I attract abundance into my life", "Abundance"),
        ("I am grateful for this moment", "Gratitude"),
        ("My potential is limitless", "Success"),
        ("I choose to be happy today", "Happiness")
    ]
    
    func placeholder(in context: Context) -> DailyGlowEntry {
        DailyGlowEntry(
            date: Date(),
            affirmation: "I am worthy of love and happiness",
            category: "Self-Love",
            streak: 7
        )
    }
    
    func getSnapshot(in context: Context, completion: @escaping (DailyGlowEntry) -> Void) {
        let entry = DailyGlowEntry(
            date: Date(),
            affirmation: "Today I choose joy and gratitude",
            category: "Gratitude",
            streak: getStreak()
        )
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<DailyGlowEntry>) -> Void) {
        var entries: [DailyGlowEntry] = []
        let currentDate = Date()
        
        // Generate entries for the next 24 hours, updating every 4 hours
        for hourOffset in stride(from: 0, to: 24, by: 4) {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let randomAffirmation = affirmations.randomElement() ?? affirmations[0]
            
            let entry = DailyGlowEntry(
                date: entryDate,
                affirmation: randomAffirmation.0,
                category: randomAffirmation.1,
                streak: getStreak()
            )
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
    
    private func getStreak() -> Int {
        // Try to get streak from shared UserDefaults (App Group)
        if let sharedDefaults = UserDefaults(suiteName: "group.dailyglow") {
            return sharedDefaults.integer(forKey: "currentStreak")
        }
        return 0
    }
}

// MARK: - Small Widget View
struct SmallWidgetView: View {
    let entry: DailyGlowEntry
    
    var body: some View {
        ZStack {
            // Gradient background
            LinearGradient(
                colors: [Color.purple.opacity(0.8), Color.blue.opacity(0.6)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            VStack(spacing: 8) {
                // Sun icon
                Image(systemName: "sun.max.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.yellow)
                
                // Affirmation text (truncated for small widget)
                Text(entry.affirmation)
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
                    .padding(.horizontal, 8)
                
                // Streak indicator
                if entry.streak > 0 {
                    HStack(spacing: 2) {
                        Image(systemName: "flame.fill")
                            .font(.system(size: 10))
                        Text("\(entry.streak)")
                            .font(.system(size: 10, weight: .bold))
                    }
                    .foregroundColor(.orange)
                }
            }
            .padding(12)
        }
    }
}

// MARK: - Medium Widget View
struct MediumWidgetView: View {
    let entry: DailyGlowEntry
    
    var body: some View {
        ZStack {
            // Gradient background
            LinearGradient(
                colors: [Color.purple.opacity(0.8), Color.blue.opacity(0.6)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            HStack(spacing: 16) {
                // Left side - Icon and streak
                VStack(spacing: 8) {
                    Image(systemName: "sun.max.fill")
                        .font(.system(size: 36))
                        .foregroundColor(.yellow)
                    
                    if entry.streak > 0 {
                        HStack(spacing: 4) {
                            Image(systemName: "flame.fill")
                                .font(.system(size: 14))
                            Text("\(entry.streak)")
                                .font(.system(size: 14, weight: .bold))
                        }
                        .foregroundColor(.orange)
                    }
                }
                .frame(width: 60)
                
                // Right side - Affirmation
                VStack(alignment: .leading, spacing: 4) {
                    Text(entry.category.uppercased())
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(.white.opacity(0.7))
                    
                    Text(entry.affirmation)
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                        .lineLimit(3)
                }
                
                Spacer()
            }
            .padding(16)
        }
    }
}

// MARK: - Large Widget View
struct LargeWidgetView: View {
    let entry: DailyGlowEntry
    
    var body: some View {
        ZStack {
            // Gradient background
            LinearGradient(
                colors: [Color.purple.opacity(0.8), Color.blue.opacity(0.6)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            VStack(spacing: 16) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Daily Glow")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        Text(entry.category.uppercased())
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(.white.opacity(0.7))
                    }
                    
                    Spacer()
                    
                    // Sun icon
                    Image(systemName: "sun.max.fill")
                        .font(.system(size: 32))
                        .foregroundColor(.yellow)
                }
                
                Spacer()
                
                // Main affirmation
                Text(entry.affirmation)
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 1)
                
                Spacer()
                
                // Footer with streak
                HStack {
                    if entry.streak > 0 {
                        HStack(spacing: 6) {
                            Image(systemName: "flame.fill")
                                .font(.system(size: 16))
                            Text("\(entry.streak) day streak")
                                .font(.system(size: 14, weight: .semibold))
                        }
                        .foregroundColor(.orange)
                    }
                    
                    Spacer()
                    
                    Text("Tap to open")
                        .font(.system(size: 11))
                        .foregroundColor(.white.opacity(0.6))
                }
            }
            .padding(20)
        }
    }
}

// MARK: - Widget Configuration
@main
struct DailyGlowWidget: Widget {
    let kind: String = "DailyGlowWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: DailyGlowProvider()) { entry in
            if #available(iOS 17.0, *) {
                WidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                WidgetEntryView(entry: entry)
            }
        }
        .configurationDisplayName("Daily Glow")
        .description("Your daily dose of positivity and affirmations.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

// MARK: - Widget Entry View (switches based on size)
struct WidgetEntryView: View {
    @Environment(\.widgetFamily) var family
    let entry: DailyGlowEntry
    
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

// MARK: - Previews
#Preview("Small", as: .systemSmall) {
    DailyGlowWidget()
} timeline: {
    DailyGlowEntry(date: .now, affirmation: "I am worthy of love and happiness", category: "Self-Love", streak: 7)
}

#Preview("Medium", as: .systemMedium) {
    DailyGlowWidget()
} timeline: {
    DailyGlowEntry(date: .now, affirmation: "Today I choose joy and gratitude", category: "Gratitude", streak: 14)
}

#Preview("Large", as: .systemLarge) {
    DailyGlowWidget()
} timeline: {
    DailyGlowEntry(date: .now, affirmation: "I am capable of achieving anything I set my mind to", category: "Success", streak: 30)
}
