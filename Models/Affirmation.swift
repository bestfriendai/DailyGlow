import Foundation
import SwiftUI

// MARK: - Affirmation Model

struct Affirmation: Identifiable, Codable, Hashable {
    let id: UUID
    var text: String
    var category: Category
    var isFavorite: Bool
    var dateAdded: Date
    var lastShown: Date?
    var showCount: Int
    
    init(
        id: UUID = UUID(),
        text: String,
        category: Category,
        isFavorite: Bool = false,
        dateAdded: Date = Date(),
        lastShown: Date? = nil,
        showCount: Int = 0
    ) {
        self.id = id
        self.text = text
        self.category = category
        self.isFavorite = isFavorite
        self.dateAdded = dateAdded
        self.lastShown = lastShown
        self.showCount = showCount
    }
    
    func getDisplayText(userName: String = "") -> String {
        if userName.isEmpty {
            return text
        }
        return text.replacingOccurrences(of: "[NAME]", with: userName)
    }
    
    mutating func markAsShown() {
        lastShown = Date()
        showCount += 1
    }
}

// MARK: - Sample Affirmations

extension Affirmation {
    static var sampleAffirmations: [Affirmation] {
        [
            Affirmation(text: "I am worthy of love and respect", category: .selfLove),
            Affirmation(text: "Success flows to me easily", category: .success),
            Affirmation(text: "My body is healthy and strong", category: .health),
            Affirmation(text: "I attract positive relationships", category: .relationships),
            Affirmation(text: "Abundance flows into my life", category: .abundance),
            Affirmation(text: "I radiate confidence", category: .confidence),
            Affirmation(text: "I am grateful for all I have", category: .gratitude),
            Affirmation(text: "Peace flows through me", category: .peace),
            Affirmation(text: "My creativity has no limits", category: .creativity),
            Affirmation(text: "I am present and mindful", category: .mindfulness),
            Affirmation(text: "I am strong and resilient", category: .strength),
            Affirmation(text: "Joy fills my heart", category: .joy)
        ]
    }
}
