import SwiftUI

// MARK: - Category Picker View (Page 5)

struct CategoryPickerView: View {
    let onContinue: () -> Void
    @AppStorage("selectedCategories") private var selectedCategoriesData: Data = Data()
    @State private var selectedCategories: Set<Category> = []
    
    private let minSelection = 3
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(spacing: 12) {
                Text("Choose your focus areas")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.textPrimary)
                
                Text("Select at least \(minSelection) categories that resonate with you")
                    .font(.system(size: 16))
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
                
                // Selection counter
                HStack(spacing: 8) {
                    Text("\(selectedCategories.count)")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(selectedCategories.count >= minSelection ? .glowGold : .textPrimary)
                    
                    Text("/ \(minSelection) minimum")
                        .font(.system(size: 14))
                        .foregroundColor(.textTertiary)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(
                    Capsule()
                        .fill(Color.cardDark)
                        .overlay(
                            Capsule()
                                .stroke(
                                    selectedCategories.count >= minSelection ? Color.glowGold : Color.cardBorder,
                                    lineWidth: 1
                                )
                        )
                )
            }
            .padding(.top, 20)
            .padding(.horizontal, 20)
            
            // Categories grid
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    ForEach(Category.allCases, id: \.self) { category in
                        CategoryCard(
                            category: category,
                            isSelected: selectedCategories.contains(category)
                        ) {
                            withAnimation(.spring(response: 0.3)) {
                                if selectedCategories.contains(category) {
                                    selectedCategories.remove(category)
                                } else {
                                    selectedCategories.insert(category)
                                }
                            }
                            HapticManager.shared.impact(.light)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 24)
                .padding(.bottom, 20)
            }
            
            // Quick select
            VStack(spacing: 16) {
                Text("QUICK SELECT")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.textMuted)
                
                HStack(spacing: 12) {
                    SecondaryButton(title: "Select All") {
                        withAnimation {
                            selectedCategories = Set(Category.allCases)
                        }
                    }
                    
                    SecondaryButton(title: "Popular") {
                        withAnimation {
                            selectedCategories = [.selfLove, .confidence, .success, .gratitude]
                        }
                    }
                    
                    SecondaryButton(title: "Clear") {
                        withAnimation {
                            selectedCategories = []
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
            
            // CTA
            PrimaryButton(
                title: "Continue",
                icon: "arrow.right",
                isDisabled: selectedCategories.count < minSelection
            ) {
                saveCategories()
                onContinue()
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 50)
        }
    }
    
    private func saveCategories() {
        let categoryStrings = selectedCategories.map { $0.rawValue }
        if let encoded = try? JSONEncoder().encode(categoryStrings) {
            selectedCategoriesData = encoded
        }
    }
}

// MARK: - Category Card

struct CategoryCard: View {
    let category: Category
    let isSelected: Bool
    let action: () -> Void
    
    private var categoryColor: Color {
        switch category {
        case .selfLove: return .categorySelfLove
        case .success: return .categorySuccess
        case .health: return .categoryHealth
        case .relationships: return .categoryRelationships
        case .abundance: return .categoryAbundance
        case .confidence: return .categoryConfidence
        case .gratitude: return .categoryGratitude
        case .peace: return .categoryPeace
        case .creativity: return .categoryCreativity
        case .mindfulness: return .categoryMindfulness
        case .strength: return .categoryStrength
        case .joy: return .categoryJoy
        }
    }
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 10) {
                // Icon
                Image(systemName: category.icon)
                    .font(.system(size: 24))
                    .foregroundColor(isSelected ? .white : categoryColor)
                    .frame(width: 50, height: 50)
                    .background(
                        Circle()
                            .fill(isSelected ? categoryColor : categoryColor.opacity(0.15))
                    )
                
                // Name
                Text(category.displayName)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(isSelected ? .textPrimary : .textSecondary)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? categoryColor.opacity(0.15) : Color.cardDark)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(isSelected ? categoryColor : Color.cardBorder, lineWidth: isSelected ? 2 : 1)
                    )
            )
        }
        .scaleEffect(isSelected ? 1.02 : 1)
        .animation(.spring(response: 0.3), value: isSelected)
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        AnimatedBackground(style: .cosmic)
        CategoryPickerView(onContinue: {})
    }
}
