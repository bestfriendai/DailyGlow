import Foundation
import SwiftUI

// MARK: - Category Model

enum Category: String, CaseIterable, Codable, Identifiable {
    case selfLove = "Self Love"
    case success = "Success"
    case health = "Health"
    case relationships = "Relationships"
    case abundance = "Abundance"
    case confidence = "Confidence"
    case gratitude = "Gratitude"
    case peace = "Peace"
    case creativity = "Creativity"
    case mindfulness = "Mindfulness"
    case strength = "Strength"
    case joy = "Joy"
    
    var id: String { rawValue }
    
    var displayName: String {
        rawValue
    }
    
    var icon: String {
        switch self {
        case .selfLove: return "heart.fill"
        case .success: return "star.fill"
        case .health: return "heart.circle.fill"
        case .relationships: return "person.2.fill"
        case .abundance: return "sparkles"
        case .confidence: return "person.fill.checkmark"
        case .gratitude: return "hands.sparkles.fill"
        case .peace: return "leaf.fill"
        case .creativity: return "paintbrush.fill"
        case .mindfulness: return "brain.head.profile"
        case .strength: return "bolt.fill"
        case .joy: return "face.smiling.fill"
        }
    }
    
    var color: Color {
        switch self {
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
    
    var description: String {
        switch self {
        case .selfLove: return "Embrace self-love and acceptance"
        case .success: return "Attract achievement and prosperity"
        case .health: return "Nurture your body and wellness"
        case .relationships: return "Strengthen connections with others"
        case .abundance: return "Welcome prosperity and wealth"
        case .confidence: return "Build unshakeable self-belief"
        case .gratitude: return "Cultivate appreciation and joy"
        case .peace: return "Find calm and tranquility"
        case .creativity: return "Unlock your creative potential"
        case .mindfulness: return "Stay present and aware"
        case .strength: return "Build inner resilience"
        case .joy: return "Embrace happiness daily"
        }
    }
}

// MARK: - Mood Model

enum Mood: String, CaseIterable, Identifiable, Codable {
    case energized = "Energized"
    case calm = "Calm"
    case focused = "Focused"
    case happy = "Happy"
    case grateful = "Grateful"
    case confident = "Confident"
    case peaceful = "Peaceful"
    case motivated = "Motivated"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .energized: return "bolt.fill"
        case .calm: return "leaf.fill"
        case .focused: return "eye.fill"
        case .happy: return "face.smiling.fill"
        case .grateful: return "heart.fill"
        case .confident: return "star.fill"
        case .peaceful: return "moon.stars.fill"
        case .motivated: return "flame.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .energized: return .moodEnergized
        case .calm: return .moodCalm
        case .focused: return .moodFocused
        case .happy: return .moodHappy
        case .grateful: return .moodGrateful
        case .confident: return .categoryConfidence
        case .peaceful: return .categoryPeace
        case .motivated: return .moodMotivated
        }
    }
    
    var suggestedCategories: [Category] {
        switch self {
        case .energized: return [.strength, .success, .confidence]
        case .calm: return [.peace, .mindfulness, .gratitude]
        case .focused: return [.success, .strength, .confidence]
        case .happy: return [.joy, .gratitude, .selfLove]
        case .grateful: return [.gratitude, .abundance, .selfLove]
        case .confident: return [.confidence, .success, .strength]
        case .peaceful: return [.peace, .mindfulness, .gratitude]
        case .motivated: return [.strength, .success, .abundance]
        }
    }
}
