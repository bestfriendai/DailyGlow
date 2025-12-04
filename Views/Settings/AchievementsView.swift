import SwiftUI

// MARK: - Achievements View

struct AchievementsView: View {
    @Environment(\.dismiss) var dismiss
    @AppStorage("currentStreak") private var currentStreak = 1
    @AppStorage("totalAffirmationsViewed") private var totalViewed = 0
    @AppStorage("journalEntries") private var journalEntriesData: Data = Data()
    
    private var journalCount: Int {
        if let decoded = try? JSONDecoder().decode([JournalEntry].self, from: journalEntriesData) {
            return decoded.count
        }
        return 0
    }
    
    var body: some View {
        ZStack {
            DarkBackground()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    headerView
                    
                    // Stats overview
                    statsOverview
                    
                    // Achievements grid
                    achievementsGrid
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
        }
    }
    
    // MARK: - Header
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Achievements")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.textPrimary)
                
                Text("Your progress journey")
                    .font(.system(size: 14))
                    .foregroundColor(.textTertiary)
            }
            
            Spacer()
            
            IconButton(icon: "xmark", size: 36, iconSize: 16) {
                dismiss()
            }
        }
        .padding(.top, 20)
    }
    
    // MARK: - Stats Overview
    
    private var statsOverview: some View {
        HStack(spacing: 16) {
            StatBadge(
                value: "\(currentStreak)",
                label: "Day Streak",
                icon: "flame.fill",
                color: .streakFlame
            )
            
            StatBadge(
                value: "\(totalViewed)",
                label: "Affirmations",
                icon: "sun.max.fill",
                color: .glowGold
            )
            
            StatBadge(
                value: "\(journalCount)",
                label: "Journal Entries",
                icon: "book.fill",
                color: .glowTeal
            )
        }
    }
    
    // MARK: - Achievements Grid
    
    private var achievementsGrid: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("BADGES")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.textTertiary)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                // Streak achievements - using FLAME badges
                AchievementCard(
                    title: "First Flame",
                    description: "Complete day 1",
                    badgeImage: "BadgeFlame1",
                    color: .achievementBronze,
                    isUnlocked: currentStreak >= 1
                )
                
                AchievementCard(
                    title: "Week Warrior",
                    description: "7 day streak",
                    badgeImage: "BadgeFlame2",
                    color: .achievementSilver,
                    isUnlocked: currentStreak >= 7
                )
                
                AchievementCard(
                    title: "Burning Bright",
                    description: "14 day streak",
                    badgeImage: "BadgeFlame3",
                    color: .streakFlame,
                    isUnlocked: currentStreak >= 14
                )
                
                AchievementCard(
                    title: "Monthly Master",
                    description: "30 day streak",
                    badgeImage: "BadgeFlame4",
                    color: .achievementGold,
                    isUnlocked: currentStreak >= 30
                )
                
                // Crown achievements - milestones
                AchievementCard(
                    title: "Rising Star",
                    description: "View 50 affirmations",
                    badgeImage: "BadgeStar1",
                    color: .glowPurple,
                    isUnlocked: totalViewed >= 50
                )
                
                AchievementCard(
                    title: "Shining Bright",
                    description: "View 200 affirmations",
                    badgeImage: "BadgeStar2",
                    color: .glowGold,
                    isUnlocked: totalViewed >= 200
                )
                
                AchievementCard(
                    title: "Superstar",
                    description: "View 500 affirmations",
                    badgeImage: "BadgeStar3",
                    color: .achievementGold,
                    isUnlocked: totalViewed >= 500
                )
                
                // Crown - premium achievements
                AchievementCard(
                    title: "Century Club",
                    description: "100 day streak",
                    badgeImage: "BadgeCrown1",
                    color: .achievementPlatinum,
                    isUnlocked: currentStreak >= 100
                )
                
                AchievementCard(
                    title: "Journaler",
                    description: "Write 10 entries",
                    badgeImage: "BadgeCrown2",
                    color: .glowTeal,
                    isUnlocked: journalCount >= 10
                )
                
                AchievementCard(
                    title: "Prolific Writer",
                    description: "Write 50 entries",
                    badgeImage: "BadgeCrown3",
                    color: .glowTeal,
                    isUnlocked: journalCount >= 50
                )
            }
        }
    }
}

// MARK: - Stat Badge

struct StatBadge: View {
    let value: String
    let label: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(color)
            
            Text(value)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.textPrimary)
            
            Text(label)
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(.textTertiary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.cardDark)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(color.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

// MARK: - Achievement Card

struct AchievementCard: View {
    let title: String
    let description: String
    let badgeImage: String  // Uses our generated badge images!
    let color: Color
    let isUnlocked: Bool
    
    var body: some View {
        VStack(spacing: 12) {
            // Badge Image
            ZStack {
                if isUnlocked {
                    // Glow effect
                    Circle()
                        .fill(color)
                        .frame(width: 80, height: 80)
                        .blur(radius: 20)
                        .opacity(0.4)
                }
                
                // The actual badge image
                Image(badgeImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 70, height: 70)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(isUnlocked ? color : Color.cardBorder, lineWidth: 2)
                    )
                    .saturation(isUnlocked ? 1.0 : 0.0) // Grayscale when locked
                    .opacity(isUnlocked ? 1.0 : 0.5)
                
                // Lock overlay when not unlocked
                if !isUnlocked {
                    Circle()
                        .fill(Color.black.opacity(0.5))
                        .frame(width: 70, height: 70)
                    
                    Image(systemName: "lock.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.textMuted)
                }
            }
            
            // Text
            VStack(spacing: 4) {
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(isUnlocked ? .textPrimary : .textTertiary)
                
                Text(description)
                    .font(.system(size: 11))
                    .foregroundColor(.textMuted)
            }
            
            // Status checkmark when unlocked
            if isUnlocked {
                HStack(spacing: 4) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 14))
                        .foregroundColor(.success)
                    Text("Unlocked!")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(.success)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(isUnlocked ? color.opacity(0.1) : Color.cardDark)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(isUnlocked ? color.opacity(0.3) : Color.cardBorder, lineWidth: 1)
                )
        )
    }
}

// MARK: - Preview

#Preview {
    AchievementsView()
}
