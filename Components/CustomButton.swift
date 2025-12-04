import SwiftUI

// MARK: - Premium Button Styles

struct PrimaryButton: View {
    let title: String
    var icon: String? = nil
    var isLoading: Bool = false
    var isDisabled: Bool = false
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .black))
                        .scaleEffect(0.8)
                } else {
                    if let icon = icon {
                        Image(systemName: icon)
                            .font(.system(size: 18, weight: .semibold))
                    }
                    Text(title)
                        .font(.system(size: 17, weight: .semibold))
                }
            }
            .foregroundColor(.black)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(
                ZStack {
                    // Shadow glow
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.glowGold)
                        .blur(radius: 15)
                        .opacity(isDisabled ? 0 : 0.5)
                        .offset(y: 5)
                    
                    // Main button
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                colors: isDisabled 
                                    ? [Color.gray.opacity(0.3), Color.gray.opacity(0.2)]
                                    : [Color.glowGold, Color.glowGoldDark],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                    
                    // Top highlight
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                        .mask(
                            LinearGradient(
                                colors: [Color.white, Color.clear],
                                startPoint: .top,
                                endPoint: .center
                            )
                        )
                }
            )
        }
        .disabled(isDisabled || isLoading)
        .opacity(isDisabled ? 0.6 : 1)
    }
}

// MARK: - Secondary Button

struct SecondaryButton: View {
    let title: String
    var icon: String? = nil
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .medium))
                }
                Text(title)
                    .font(.system(size: 16, weight: .medium))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.white.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
            )
        }
    }
}

// MARK: - Ghost Button

struct GhostButton: View {
    let title: String
    var color: Color = .white
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(color.opacity(0.7))
        }
    }
}

// MARK: - Icon Button

struct IconButton: View {
    let icon: String
    var size: CGFloat = 44
    var iconSize: CGFloat = 20
    var backgroundColor: Color = Color.white.opacity(0.1)
    var iconColor: Color = .white
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: iconSize, weight: .medium))
                .foregroundColor(iconColor)
                .frame(width: size, height: size)
                .background(
                    Circle()
                        .fill(backgroundColor)
                        .overlay(
                            Circle()
                                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                        )
                )
        }
    }
}

// MARK: - Pill Button (for tags/filters)

struct PillButton: View {
    let title: String
    var icon: String? = nil
    let isSelected: Bool
    var selectedColor: Color = .glowGold
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 14, weight: .medium))
                }
                Text(title)
                    .font(.system(size: 14, weight: .medium))
            }
            .foregroundColor(isSelected ? .black : .white.opacity(0.8))
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                Capsule()
                    .fill(isSelected ? selectedColor : Color.white.opacity(0.1))
                    .overlay(
                        Capsule()
                            .stroke(
                                isSelected ? Color.clear : Color.white.opacity(0.15),
                                lineWidth: 1
                            )
                    )
            )
        }
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

// MARK: - Floating Action Button

struct FloatingActionButton: View {
    let icon: String
    var gradientColors: [Color] = [.glowGold, .glowGoldDark]
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(.black)
                .frame(width: 60, height: 60)
                .background(
                    ZStack {
                        Circle()
                            .fill(Color.glowGold)
                            .blur(radius: 15)
                            .opacity(0.6)
                            .offset(y: 5)
                        
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: gradientColors,
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    }
                )
        }
        .shadow(color: Color.glowGold.opacity(0.3), radius: 10, y: 5)
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        AnimatedBackground(style: .cosmic)
        
        VStack(spacing: 20) {
            PrimaryButton(title: "Get Started", icon: "arrow.right") {}
            
            SecondaryButton(title: "Maybe Later", icon: "clock") {}
            
            GhostButton(title: "Skip") {}
            
            HStack(spacing: 15) {
                IconButton(icon: "heart.fill", iconColor: .red) {}
                IconButton(icon: "square.and.arrow.up") {}
                IconButton(icon: "bookmark") {}
            }
            
            HStack(spacing: 10) {
                PillButton(title: "All", isSelected: true) {}
                PillButton(title: "Favorites", icon: "heart", isSelected: false) {}
                PillButton(title: "Recent", isSelected: false) {}
            }
            
            Spacer()
            
            FloatingActionButton(icon: "plus") {}
        }
        .padding()
    }
}
