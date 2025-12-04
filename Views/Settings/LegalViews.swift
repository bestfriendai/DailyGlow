//
//  LegalViews.swift
//  DailyGlow
//
//  Privacy Policy and Terms of Service views
//  Required for App Store submission!
//

import SwiftUI

// MARK: - Privacy Policy View
struct PrivacyPolicyView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    Group {
                        Text("Privacy Policy")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text("Last updated: \(Date().formatted(date: .long, time: .omitted))")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Divider()
                    }
                    
                    Group {
                        sectionTitle("Introduction")
                        sectionBody("""
                        Welcome to Daily Glow ("we," "our," or "us"). We are committed to protecting your privacy and personal information. This Privacy Policy explains how we collect, use, and safeguard your data when you use our Daily Glow mobile application (the "App").
                        
                        By using the App, you agree to the collection and use of information in accordance with this policy.
                        """)
                    }
                    
                    Group {
                        sectionTitle("Information We Collect")
                        sectionBody("""
                        We collect minimal information to provide you with the best experience:
                        
                        • **Personal Preferences**: Your name (if provided), selected affirmation categories, notification preferences, and app settings.
                        
                        • **Usage Data**: Anonymous data about how you use the app, including affirmations viewed, favorites saved, and journal entries (stored locally on your device only).
                        
                        • **Device Information**: Basic device information for crash reporting and app optimization.
                        
                        We do NOT collect:
                        • Your location
                        • Your contacts
                        • Your photos or media
                        • Any personally identifiable information without your explicit consent
                        """)
                    }
                    
                    Group {
                        sectionTitle("How We Use Your Information")
                        sectionBody("""
                        We use the information we collect to:
                        
                        • Personalize your affirmation experience
                        • Save your preferences and favorites
                        • Send you daily reminder notifications (if enabled)
                        • Improve the app and fix bugs
                        • Process in-app purchases through Apple's secure systems
                        """)
                    }
                    
                    Group {
                        sectionTitle("Data Storage")
                        sectionBody("""
                        Your data is stored locally on your device. We do not upload your personal data, journal entries, or usage patterns to external servers.
                        
                        If you use iCloud backup, your app data may be included in your device backup, which is protected by Apple's security measures.
                        """)
                    }
                    
                    Group {
                        sectionTitle("Third-Party Services")
                        sectionBody("""
                        The App uses the following third-party services:
                        
                        • **Apple StoreKit**: For processing in-app purchases securely
                        • **Apple Push Notification Service**: For sending daily reminders
                        
                        These services are governed by Apple's privacy policies.
                        """)
                    }
                    
                    Group {
                        sectionTitle("Children's Privacy")
                        sectionBody("""
                        The App is suitable for all ages. We do not knowingly collect personal information from children under 13. If you are a parent or guardian and believe your child has provided us with personal information, please contact us.
                        """)
                    }
                    
                    Group {
                        sectionTitle("Your Rights")
                        sectionBody("""
                        You have the right to:
                        
                        • Access your data stored in the app
                        • Delete your data using the "Reset All Data" option in Settings
                        • Opt out of notifications at any time
                        • Request information about your data
                        """)
                    }
                    
                    Group {
                        sectionTitle("Changes to This Policy")
                        sectionBody("""
                        We may update this Privacy Policy from time to time. We will notify you of any changes by posting the new policy in the app. You are advised to review this policy periodically.
                        """)
                    }
                    
                    Group {
                        sectionTitle("Contact Us")
                        sectionBody("""
                        If you have any questions about this Privacy Policy, please contact us at:
                        
                        Email: support@dailyglow.app
                        """)
                    }
                    
                    Spacer(minLength: 50)
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(.title2)
            .fontWeight(.semibold)
            .padding(.top, 10)
    }
    
    private func sectionBody(_ text: String) -> some View {
        Text(.init(text))
            .font(.body)
            .foregroundColor(.secondary)
            .fixedSize(horizontal: false, vertical: true)
    }
}

// MARK: - Terms of Service View
struct TermsOfServiceView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    Group {
                        Text("Terms of Service")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text("Last updated: \(Date().formatted(date: .long, time: .omitted))")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Divider()
                    }
                    
                    Group {
                        sectionTitle("1. Agreement to Terms")
                        sectionBody("""
                        By downloading, installing, or using Daily Glow (the "App"), you agree to be bound by these Terms of Service ("Terms"). If you do not agree to these Terms, do not use the App.
                        """)
                    }
                    
                    Group {
                        sectionTitle("2. Description of Service")
                        sectionBody("""
                        Daily Glow is a mobile application that provides:
                        
                        • Daily affirmations for personal growth
                        • Journaling features
                        • Mood tracking
                        • Gamification elements including streaks and achievements
                        
                        The App offers both free and premium subscription features.
                        """)
                    }
                    
                    Group {
                        sectionTitle("3. Subscriptions and Payments")
                        sectionBody("""
                        **Premium Features**: Some features require a paid subscription ("Daily Glow Premium").
                        
                        **Pricing**: Current subscription options include weekly, monthly, yearly, and lifetime plans. Prices are displayed in the App and may vary by region.
                        
                        **Billing**: Payment will be charged to your Apple ID account at the confirmation of purchase.
                        
                        **Renewal**: Subscriptions automatically renew unless auto-renew is turned off at least 24 hours before the end of the current period.
                        
                        **Management**: You can manage or cancel subscriptions in your App Store account settings.
                        
                        **Refunds**: Refund requests are handled by Apple according to their refund policies.
                        """)
                    }
                    
                    Group {
                        sectionTitle("4. Free Trial")
                        sectionBody("""
                        If offered, free trials automatically convert to paid subscriptions unless cancelled before the trial ends. You will not be charged during the free trial period.
                        """)
                    }
                    
                    Group {
                        sectionTitle("5. User Conduct")
                        sectionBody("""
                        You agree to use the App only for lawful purposes and in accordance with these Terms. You agree not to:
                        
                        • Use the App in any way that violates applicable laws
                        • Attempt to gain unauthorized access to any part of the App
                        • Interfere with or disrupt the App's operation
                        • Copy, modify, or distribute the App's content without permission
                        """)
                    }
                    
                    Group {
                        sectionTitle("6. Intellectual Property")
                        sectionBody("""
                        The App, including all content, features, and functionality, is owned by Daily Glow and is protected by copyright, trademark, and other intellectual property laws.
                        
                        The affirmations, designs, and other content in the App may not be copied, reproduced, or distributed without our written permission.
                        """)
                    }
                    
                    Group {
                        sectionTitle("7. Disclaimer")
                        sectionBody("""
                        The App is provided "as is" without warranties of any kind. Daily Glow does not guarantee that:
                        
                        • The App will be uninterrupted or error-free
                        • The App will meet your specific requirements
                        • Results from using the App will be accurate or reliable
                        
                        **Health Disclaimer**: The App is for general wellness purposes only and is not a substitute for professional medical advice, diagnosis, or treatment. Always seek the advice of a qualified health provider with any questions about a medical condition.
                        """)
                    }
                    
                    Group {
                        sectionTitle("8. Limitation of Liability")
                        sectionBody("""
                        To the maximum extent permitted by law, Daily Glow shall not be liable for any indirect, incidental, special, consequential, or punitive damages resulting from your use of or inability to use the App.
                        """)
                    }
                    
                    Group {
                        sectionTitle("9. Changes to Terms")
                        sectionBody("""
                        We reserve the right to modify these Terms at any time. Changes will be effective immediately upon posting in the App. Your continued use of the App following any changes constitutes acceptance of the new Terms.
                        """)
                    }
                    
                    Group {
                        sectionTitle("10. Termination")
                        sectionBody("""
                        We may terminate or suspend your access to the App at any time, without prior notice, for conduct that we believe violates these Terms or is harmful to other users, us, or third parties.
                        """)
                    }
                    
                    Group {
                        sectionTitle("11. Governing Law")
                        sectionBody("""
                        These Terms shall be governed by and construed in accordance with the laws of the United States, without regard to its conflict of law provisions.
                        """)
                    }
                    
                    Group {
                        sectionTitle("12. Contact Us")
                        sectionBody("""
                        If you have any questions about these Terms, please contact us at:
                        
                        Email: support@dailyglow.app
                        """)
                    }
                    
                    Spacer(minLength: 50)
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(.title2)
            .fontWeight(.semibold)
            .padding(.top, 10)
    }
    
    private func sectionBody(_ text: String) -> some View {
        Text(.init(text))
            .font(.body)
            .foregroundColor(.secondary)
            .fixedSize(horizontal: false, vertical: true)
    }
}

// MARK: - Previews
#Preview("Privacy Policy") {
    PrivacyPolicyView()
}

#Preview("Terms of Service") {
    TermsOfServiceView()
}

