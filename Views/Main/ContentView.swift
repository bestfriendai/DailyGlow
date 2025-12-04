import SwiftUI

// MARK: - Main Content View with Custom Tab Bar

struct ContentView: View {
    @StateObject private var affirmationService = AffirmationService.shared
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @AppStorage("isPremium") private var isPremium = false
    @State private var selectedTab: Tab = .today
    @State private var showPaywall = false
    
    enum Tab: String, CaseIterable {
        case today = "Today"
        case favorites = "Favorites"
        case journal = "Journal"
        case settings = "Settings"
        
        var icon: String {
            switch self {
            case .today: return "sun.max.fill"
            case .favorites: return "heart.fill"
            case .journal: return "book.fill"
            case .settings: return "gearshape.fill"
            }
        }
    }
    
    var body: some View {
        Group {
            if hasCompletedOnboarding {
                mainContent
            } else {
                OnboardingContainer()
            }
        }
        .sheet(isPresented: $showPaywall) {
            PaywallView()
        }
    }
    
    private var mainContent: some View {
        ZStack(alignment: .bottom) {
            // Tab content
            Group {
                switch selectedTab {
                case .today:
                    TodayTab()
                case .favorites:
                    FavoritesTab()
                case .journal:
                    JournalTab()
                case .settings:
                    SettingsTab()
                }
            }
            .environmentObject(affirmationService)
            
            // Custom Tab Bar
            customTabBar
        }
    }
    
    private var customTabBar: some View {
        HStack(spacing: 0) {
            ForEach(Tab.allCases, id: \.self) { tab in
                tabButton(for: tab)
            }
        }
        .padding(.horizontal, 8)
        .padding(.top, 12)
        .padding(.bottom, 28)
        .background(
            ZStack {
                // Blur background
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .opacity(0.8)
                
                // Dark overlay
                Rectangle()
                    .fill(Color.tabBarBackground)
                
                // Top border
                VStack {
                    Rectangle()
                        .fill(Color.white.opacity(0.1))
                        .frame(height: 0.5)
                    Spacer()
                }
            }
            .ignoresSafeArea()
        )
    }
    
    private func tabButton(for tab: Tab) -> some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selectedTab = tab
            }
            HapticManager.shared.impact(.light)
        } label: {
            VStack(spacing: 6) {
                // Icon with glow effect when selected
                ZStack {
                    if selectedTab == tab {
                        Image(systemName: tab.icon)
                            .font(.system(size: 22))
                            .foregroundColor(.tabBarSelected)
                            .blur(radius: 8)
                            .opacity(0.6)
                    }
                    
                    Image(systemName: tab.icon)
                        .font(.system(size: 22))
                        .foregroundColor(selectedTab == tab ? .tabBarSelected : .tabBarUnselected)
                }
                .frame(height: 26)
                
                // Label
                Text(tab.rawValue)
                    .font(.system(size: 11, weight: selectedTab == tab ? .semibold : .medium))
                    .foregroundColor(selectedTab == tab ? .tabBarSelected : .tabBarUnselected)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

// MARK: - Preview

#Preview {
    ContentView()
}
