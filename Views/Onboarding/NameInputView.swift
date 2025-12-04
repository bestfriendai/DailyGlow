import SwiftUI

// MARK: - Name Input View (Page 3)

struct NameInputView: View {
    let onContinue: () -> Void
    @AppStorage("userName") private var userName = ""
    @State private var inputName = ""
    @FocusState private var isNameFocused: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            // Content
            VStack(spacing: 32) {
                // Icon
                ZStack {
                    Circle()
                        .fill(Color.glowPurple.opacity(0.2))
                        .frame(width: 100, height: 100)
                    
                    Image(systemName: "person.fill")
                        .font(.system(size: 44))
                        .foregroundColor(.glowPurple)
                }
                
                // Text
                VStack(spacing: 12) {
                    Text("What's your name?")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.textPrimary)
                    
                    Text("We'll personalize your affirmations")
                        .font(.system(size: 16))
                        .foregroundColor(.textSecondary)
                }
                
                // Input field
                VStack(spacing: 8) {
                    TextField("Your name", text: $inputName)
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(.textPrimary)
                        .multilineTextAlignment(.center)
                        .tint(.glowGold)
                        .focused($isNameFocused)
                        .autocorrectionDisabled()
                    
                    // Underline
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: isNameFocused ? [.glowGold, .glowGoldDark] : [.cardBorder, .cardBorder],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(height: 2)
                        .animation(.easeInOut(duration: 0.2), value: isNameFocused)
                }
                .padding(.horizontal, 40)
            }
            
            Spacer()
            
            // Buttons
            VStack(spacing: 12) {
                PrimaryButton(
                    title: "Continue",
                    icon: "arrow.right",
                    isDisabled: inputName.trimmingCharacters(in: .whitespaces).isEmpty
                ) {
                    userName = inputName.trimmingCharacters(in: .whitespaces)
                    onContinue()
                }
                
                GhostButton(title: "Skip for now") {
                    onContinue()
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 50)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isNameFocused = true
            }
        }
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        AnimatedBackground(style: .aurora)
        NameInputView(onContinue: {})
    }
}
