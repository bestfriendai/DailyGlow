import SwiftUI

// MARK: - Mood Selector View (Page 4)

struct MoodSelectorView: View {
    let onContinue: () -> Void
    @AppStorage("selectedMood") private var selectedMood = ""
    @State private var selection: String? = nil
    
    private let moods: [(name: String, icon: String, color: Color)] = [
        ("Energized", "bolt.fill", .moodEnergized),
        ("Calm", "leaf.fill", .moodCalm),
        ("Focused", "eye.fill", .moodFocused),
        ("Happy", "face.smiling.fill", .moodHappy)
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            // Header
            VStack(spacing: 12) {
                Text("How do you want to feel?")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.textPrimary)
                
                Text("We'll tailor your affirmations to match")
                    .font(.system(size: 16))
                    .foregroundColor(.textSecondary)
            }
            .padding(.bottom, 40)
            
            // Mood grid
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                ForEach(moods, id: \.name) { mood in
                    MoodCard(
                        name: mood.name,
                        icon: mood.icon,
                        color: mood.color,
                        isSelected: selection == mood.name
                    ) {
                        withAnimation(.spring(response: 0.3)) {
                            selection = mood.name
                        }
                        HapticManager.shared.impact(.light)
                    }
                }
            }
            .padding(.horizontal, 20)
            
            Spacer()
            
            // CTA
            VStack(spacing: 12) {
                PrimaryButton(
                    title: "Continue",
                    icon: "arrow.right",
                    isDisabled: selection == nil
                ) {
                    if let selected = selection {
                        selectedMood = selected
                    }
                    onContinue()
                }
                
                GhostButton(title: "Skip") {
                    onContinue()
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 50)
        }
    }
}

// MARK: - Mood Card

struct MoodCard: View {
    let name: String
    let icon: String
    let color: Color
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 16) {
                // Icon
                ZStack {
                    Circle()
                        .fill(isSelected ? color : color.opacity(0.15))
                        .frame(width: 70, height: 70)
                    
                    Image(systemName: icon)
                        .font(.system(size: 30))
                        .foregroundColor(isSelected ? .white : color)
                }
                
                // Name
                Text(name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(isSelected ? .textPrimary : .textSecondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 24)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(isSelected ? color.opacity(0.15) : Color.cardDark)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(isSelected ? color : Color.cardBorder, lineWidth: isSelected ? 2 : 1)
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
        AnimatedBackground(style: .warm)
        MoodSelectorView(onContinue: {})
    }
}
