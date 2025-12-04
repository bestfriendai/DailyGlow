import SwiftUI

// MARK: - Favorites Tab

struct FavoritesTab: View {
    @EnvironmentObject var affirmationService: AffirmationService
    @State private var selectedCategory: Category? = nil
    @State private var searchText = ""
    @State private var showingAffirmation: Affirmation? = nil
    
    private var filteredFavorites: [Affirmation] {
        var favorites = affirmationService.favorites
        
        if let category = selectedCategory {
            favorites = favorites.filter { $0.category == category }
        }
        
        if !searchText.isEmpty {
            favorites = favorites.filter { 
                $0.text.localizedCaseInsensitiveContains(searchText) 
            }
        }
        
        return favorites
    }
    
    var body: some View {
        ZStack {
            // Background
            AnimatedBackground(style: .cosmic, showParticles: false)
            
            VStack(spacing: 0) {
                // Header
                headerView
                
                // Category filter
                categoryFilter
                    .padding(.top, 12)
                
                // Content
                if filteredFavorites.isEmpty {
                    emptyState
                } else {
                    favoritesList
                }
            }
        }
        .sheet(item: $showingAffirmation) { affirmation in
            affirmationDetailSheet(affirmation)
        }
    }
    
    // MARK: - Header
    
    private var headerView: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Favorites")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.textPrimary)
                    
                    Text("\(affirmationService.favorites.count) saved affirmations")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.textTertiary)
                }
                
                Spacer()
                
                // Heart icon
                Image(systemName: "heart.fill")
                    .font(.system(size: 28))
                    .foregroundColor(.red)
                    .shadow(color: .red.opacity(0.5), radius: 10)
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            
            // Search bar
            searchBar
                .padding(.horizontal, 20)
        }
    }
    
    private var searchBar: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.textTertiary)
            
            TextField("Search favorites...", text: $searchText)
                .font(.system(size: 16))
                .foregroundColor(.textPrimary)
                .tint(.glowGold)
            
            if !searchText.isEmpty {
                Button {
                    searchText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.textTertiary)
                }
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.cardDark)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color.cardBorder, lineWidth: 1)
                )
        )
    }
    
    // MARK: - Category Filter
    
    private var categoryFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                PillButton(
                    title: "All",
                    isSelected: selectedCategory == nil
                ) {
                    withAnimation(.spring(response: 0.3)) {
                        selectedCategory = nil
                    }
                }
                
                ForEach(Category.allCases, id: \.self) { category in
                    PillButton(
                        title: category.displayName,
                        icon: category.icon,
                        isSelected: selectedCategory == category
                    ) {
                        withAnimation(.spring(response: 0.3)) {
                            selectedCategory = category
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }
    
    // MARK: - Favorites List
    
    private var favoritesList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(filteredFavorites) { affirmation in
                    CompactAffirmationCard(
                        affirmation: affirmation,
                        onTap: {
                            showingAffirmation = affirmation
                        },
                        onFavorite: {
                            affirmationService.toggleFavorite(affirmation)
                            SoundManager.shared.playFavoriteRemove()
                            HapticManager.shared.impact(.medium)
                        }
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 120)
        }
    }
    
    // MARK: - Empty State
    
    private var emptyState: some View {
        VStack(spacing: 20) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(Color.cardDark)
                    .frame(width: 100, height: 100)
                
                Image(systemName: "heart")
                    .font(.system(size: 40))
                    .foregroundColor(.textTertiary)
            }
            
            VStack(spacing: 8) {
                Text(searchText.isEmpty ? "No favorites yet" : "No results found")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.textPrimary)
                
                Text(searchText.isEmpty 
                     ? "Tap the heart on any affirmation\nto save it here"
                     : "Try a different search term")
                    .font(.system(size: 16))
                    .foregroundColor(.textTertiary)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
            Spacer()
        }
    }
    
    // MARK: - Detail Sheet
    
    private func affirmationDetailSheet(_ affirmation: Affirmation) -> some View {
        ZStack {
            AnimatedBackground(style: .cosmic)
            
            VStack {
                // Drag indicator
                Capsule()
                    .fill(Color.white.opacity(0.3))
                    .frame(width: 40, height: 4)
                    .padding(.top, 12)
                
                Spacer()
                
                AffirmationCard(
                    affirmation: affirmation,
                    onFavorite: {
                        affirmationService.toggleFavorite(affirmation)
                        HapticManager.shared.impact(.medium)
                    },
                    onShare: {
                        // Share
                    }
                )
                .padding(.horizontal, 20)
                
                Spacer()
                
                // Close button
                SecondaryButton(title: "Close", icon: "xmark") {
                    showingAffirmation = nil
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    FavoritesTab()
        .environmentObject(AffirmationService.shared)
}
