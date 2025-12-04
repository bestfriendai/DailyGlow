import SwiftUI

// MARK: - Today Tab - Main Affirmation Experience

struct TodayTab: View {
    @EnvironmentObject var affirmationService: AffirmationService
    @AppStorage("userName") private var userName = ""
    @AppStorage("currentStreak") private var currentStreak = 1
    @AppStorage("selectedMood") private var selectedMood = "calm"
    
    @State private var currentIndex = 0
    @State private var showMoodPicker = false
    @State private var dragOffset: CGFloat = 0
    @State private var showShareSheet = false
    
    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "Good morning"
        case 12..<17: return "Good afternoon"
        case 17..<21: return "Good evening"
        default: return "Good night"
        }
    }
    
    private var currentAffirmations: [Affirmation] {
        affirmationService.todayAffirmations
    }
    
    var body: some View {
        ZStack {
            // Animated background
            AnimatedBackground(style: backgroundStyle)
            
            // Content
            VStack(spacing: 0) {
                // Header
                headerView
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                
                // Mood pills
                moodSelector
                    .padding(.top, 16)
                
                // Affirmation card with swipe
                cardSection
                
                // Swipe indicator
                swipeIndicator
                    .padding(.bottom, 100)
            }
        }
    }
    
    // MARK: - Background Style Based on Mood
    
    private var backgroundStyle: AnimatedBackground.BackgroundStyle {
        switch selectedMood.lowercased() {
        case "energized": return .sunrise
        case "calm": return .aurora
        case "focused": return .cosmic
        case "happy": return .warm
        default: return .cosmic
        }
    }
    
    // MARK: - Header
    
    private var headerView: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text("\(greeting),")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.textPrimary)
                
                if !userName.isEmpty {
                    Text(userName)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.glowGold)
                }
                
                Text(Date(), style: .date)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.textTertiary)
            }
            
            Spacer()
            
            // Streak badge
            streakBadge
        }
    }
    
    private var streakBadge: some View {
        HStack(spacing: 6) {
            Image(systemName: "flame.fill")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.streakFlame)
            
            Text("\(currentStreak)")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.textPrimary)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(
            Capsule()
                .fill(Color.cardDark)
                .overlay(
                    Capsule()
                        .stroke(Color.streakFlame.opacity(0.3), lineWidth: 1)
                )
        )
        .shadow(color: .streakFlame.opacity(0.3), radius: 10, y: 5)
    }
    
    // MARK: - Mood Selector
    
    private var moodSelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(Mood.allCases, id: \.self) { mood in
                    PillButton(
                        title: mood.rawValue.capitalized,
                        icon: mood.icon,
                        isSelected: selectedMood.lowercased() == mood.rawValue.lowercased()
                    ) {
                        withAnimation(.spring(response: 0.3)) {
                            selectedMood = mood.rawValue
                        }
                        HapticManager.shared.impact(.light)
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }
    
    // MARK: - Card Section
    
    private var cardSection: some View {
        GeometryReader { geometry in
            ZStack {
                if currentAffirmations.isEmpty {
                    emptyState
                } else {
                    // Cards stack
                    ForEach(Array(currentAffirmations.enumerated().reversed()), id: \.element.id) { index, affirmation in
                        if index >= currentIndex && index < currentIndex + 3 {
                            let offset = index - currentIndex
                            
                            AffirmationCard(
                                affirmation: affirmation,
                                onFavorite: {
                                    toggleFavorite(affirmation)
                                },
                                onShare: {
                                    shareAffirmation(affirmation)
                                }
                            )
                            .padding(.horizontal, 20)
                            .offset(x: index == currentIndex ? dragOffset : 0)
                            .scaleEffect(1 - CGFloat(offset) * 0.05)
                            .offset(y: CGFloat(offset) * 10)
                            .opacity(offset == 0 ? 1 : 0.5)
                            .zIndex(Double(currentAffirmations.count - index))
                            .gesture(
                                index == currentIndex ? swipeGesture : nil
                            )
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "sparkles")
                .font(.system(size: 48))
                .foregroundColor(.glowGold)
            
            Text("No affirmations yet")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.textPrimary)
            
            Text("Select your focus areas to get started")
                .font(.system(size: 16))
                .foregroundColor(.textSecondary)
        }
    }
    
    // MARK: - Swipe Gesture
    
    private var swipeGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                dragOffset = value.translation.width
            }
            .onEnded { value in
                let threshold: CGFloat = 100
                
                if value.translation.width < -threshold {
                    // Swipe left - next card
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        dragOffset = -500
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        if currentIndex < currentAffirmations.count - 1 {
                            currentIndex += 1
                        } else {
                            currentIndex = 0
                        }
                        dragOffset = 0
                    }
                    
                    HapticManager.shared.impact(.medium)
                    SoundManager.shared.playCardSwipe()
                    
                } else if value.translation.width > threshold {
                    // Swipe right - previous card
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        dragOffset = 500
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        if currentIndex > 0 {
                            currentIndex -= 1
                        } else {
                            currentIndex = currentAffirmations.count - 1
                        }
                        dragOffset = 0
                    }
                    
                    HapticManager.shared.impact(.medium)
                    SoundManager.shared.playCardSwipe()
                    
                } else {
                    // Return to center
                    withAnimation(.spring(response: 0.3)) {
                        dragOffset = 0
                    }
                }
            }
    }
    
    // MARK: - Swipe Indicator
    
    private var swipeIndicator: some View {
        VStack(spacing: 8) {
            HStack(spacing: 20) {
                Image(systemName: "arrow.left")
                Text("Swipe")
                Image(systemName: "arrow.right")
            }
            .font(.system(size: 14, weight: .medium))
            .foregroundColor(.textTertiary)
            
            // Progress dots
            if !currentAffirmations.isEmpty {
                HStack(spacing: 6) {
                    ForEach(0..<min(currentAffirmations.count, 10), id: \.self) { index in
                        Circle()
                            .fill(index == currentIndex % 10 ? Color.glowGold : Color.white.opacity(0.3))
                            .frame(width: 6, height: 6)
                    }
                }
            }
        }
    }
    
    // MARK: - Actions
    
    private func toggleFavorite(_ affirmation: Affirmation) {
        affirmationService.toggleFavorite(affirmation)
        
        if !affirmation.isFavorite {
            SoundManager.shared.playFavoriteAdd()
        } else {
            SoundManager.shared.playFavoriteRemove()
        }
        
        HapticManager.shared.impact(.medium)
    }
    
    private func shareAffirmation(_ affirmation: Affirmation) {
        // Share functionality
        HapticManager.shared.impact(.light)
    }
}

// MARK: - Mood Extension (using Category.swift's Mood)

// MARK: - Preview

#Preview {
    TodayTab()
        .environmentObject(AffirmationService.shared)
}
