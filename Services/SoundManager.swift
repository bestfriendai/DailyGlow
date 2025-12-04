//
//  SoundManager.swift
//  DailyGlow
//
//  Audio manager for all app sounds - THE PREMIUM TOUCH! 🔊✨
//

import AVFoundation
import SwiftUI

@MainActor
class SoundManager: ObservableObject {
    
    // MARK: - Singleton
    static let shared = SoundManager()
    
    // MARK: - Properties
    private var audioPlayers: [String: AVAudioPlayer] = [:]
    private var ambiencePlayer: AVAudioPlayer?
    
    @AppStorage("soundEnabled") var soundEnabled: Bool = true
    @AppStorage("ambienceEnabled") var ambienceEnabled: Bool = false
    @Published var currentAmbience: AmbienceType = .none
    
    // MARK: - Sound Types
    enum SoundType: String, CaseIterable {
        // Card interactions
        case cardSwipe = "swoosh"
        
        // Favorites
        case favoriteAdd = "favoriteadd"
        case favoriteRemove = "favoriteremove"
        
        // UI
        case buttonTap1 = "buttontap1"
        case buttonTap2 = "buttontap2"
        case buttonTap3 = "buttontap3"
        case success = "success"
        
        // Achievements
        case achievementUnlock = "achievementunlock"
        case streakMilestone = "streakmilestone"
        
        // Notifications
        case notification1 = "notification1"
        case notification2 = "notify2"
        
        var fileExtension: String {
            switch self {
            case .achievementUnlock:
                return "wav"
            default:
                return "wav"
            }
        }
    }
    
    // MARK: - Ambience Types
    enum AmbienceType: String, CaseIterable {
        case none = "None"
        case morning1 = "morning1"
        case morning2 = "morning2"
        case morning3 = "morning3"
        case morning4 = "morning4"
        case night1 = "night1"
        case night2 = "night2"
        case night3 = "night3"
        case night4 = "night4"
        
        var displayName: String {
            switch self {
            case .none: return "Off"
            case .morning1: return "Sunrise Birds"
            case .morning2: return "Morning Calm"
            case .morning3: return "Dawn Breeze"
            case .morning4: return "Early Light"
            case .night1: return "Night Crickets"
            case .night2: return "Evening Wind"
            case .night3: return "Starry Night"
            case .night4: return "Peaceful Dark"
            }
        }
        
        var icon: String {
            switch self {
            case .none: return "speaker.slash"
            case .morning1, .morning2, .morning3, .morning4: return "sun.horizon.fill"
            case .night1, .night2, .night3, .night4: return "moon.stars.fill"
            }
        }
    }
    
    // MARK: - Initialization
    private init() {
        setupAudioSession()
        preloadSounds()
    }
    
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default, options: [.mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to setup audio session: \(error)")
        }
    }
    
    private func preloadSounds() {
        // Preload frequently used sounds for instant playback
        let preloadSounds: [SoundType] = [.cardSwipe, .buttonTap1, .buttonTap2, .favoriteAdd, .success]
        
        for sound in preloadSounds {
            if let url = Bundle.main.url(forResource: sound.rawValue, withExtension: sound.fileExtension) {
                do {
                    let player = try AVAudioPlayer(contentsOf: url)
                    player.prepareToPlay()
                    audioPlayers[sound.rawValue] = player
                } catch {
                    print("Failed to preload sound \(sound.rawValue): \(error)")
                }
            }
        }
    }
    
    // MARK: - Play Sound
    func play(_ sound: SoundType, volume: Float = 1.0) {
        guard soundEnabled else { return }
        
        // Use preloaded player if available
        if let player = audioPlayers[sound.rawValue] {
            player.volume = volume
            player.currentTime = 0
            player.play()
            return
        }
        
        // Otherwise load and play
        guard let url = Bundle.main.url(forResource: sound.rawValue, withExtension: sound.fileExtension) else {
            print("Sound file not found: \(sound.rawValue).\(sound.fileExtension)")
            return
        }
        
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.volume = volume
            player.play()
            audioPlayers[sound.rawValue] = player
        } catch {
            print("Failed to play sound: \(error)")
        }
    }
    
    // MARK: - Convenience Methods
    func playCardSwipe() {
        play(.cardSwipe, volume: 0.6)
    }
    
    func playButtonTap() {
        // Randomly pick a button tap variation for variety
        let taps: [SoundType] = [.buttonTap1, .buttonTap2, .buttonTap3]
        if let randomTap = taps.randomElement() {
            play(randomTap, volume: 0.4)
        }
    }
    
    func playFavoriteAdd() {
        play(.favoriteAdd, volume: 0.7)
    }
    
    func playFavoriteRemove() {
        play(.favoriteRemove, volume: 0.5)
    }
    
    func playSuccess() {
        play(.success, volume: 0.7)
    }
    
    func playAchievementUnlock() {
        play(.achievementUnlock, volume: 0.8)
    }
    
    func playStreakMilestone() {
        play(.streakMilestone, volume: 0.9)
    }
    
    func playNotification() {
        let notifications: [SoundType] = [.notification1, .notification2]
        if let randomNotif = notifications.randomElement() {
            play(randomNotif, volume: 0.8)
        }
    }
    
    // MARK: - Ambience
    func startAmbience(_ type: AmbienceType) {
        stopAmbience()
        
        guard type != .none, ambienceEnabled else {
            currentAmbience = .none
            return
        }
        
        guard let url = Bundle.main.url(forResource: type.rawValue, withExtension: "wav") else {
            print("Ambience file not found: \(type.rawValue)")
            return
        }
        
        do {
            ambiencePlayer = try AVAudioPlayer(contentsOf: url)
            ambiencePlayer?.numberOfLoops = -1 // Loop forever
            ambiencePlayer?.volume = 0.3
            ambiencePlayer?.play()
            currentAmbience = type
        } catch {
            print("Failed to play ambience: \(error)")
        }
    }
    
    func stopAmbience() {
        ambiencePlayer?.stop()
        ambiencePlayer = nil
        currentAmbience = .none
    }
    
    func setAmbienceVolume(_ volume: Float) {
        ambiencePlayer?.volume = volume
    }
    
    // MARK: - Time-Based Ambience
    func playTimeAppropriateAmbience() {
        guard ambienceEnabled else { return }
        
        let hour = Calendar.current.component(.hour, from: Date())
        
        let ambience: AmbienceType
        switch hour {
        case 5..<12:
            ambience = [.morning1, .morning2, .morning3, .morning4].randomElement() ?? .morning1
        case 12..<18:
            ambience = [.morning3, .morning4].randomElement() ?? .morning3
        default:
            ambience = [.night1, .night2, .night3, .night4].randomElement() ?? .night1
        }
        
        startAmbience(ambience)
    }
}

// MARK: - HapticManager Extension (Wire sounds to haptics)
extension HapticManager {
    
    /// Play haptic + sound together for premium feel
    func playWithSound(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        notification(type)
        
        switch type {
        case .success:
            SoundManager.shared.playSuccess()
        case .error:
            // No sound for errors
            break
        case .warning:
            // No sound for warnings
            break
        @unknown default:
            break
        }
    }
    
    func playCardSwipeWithSound() {
        playCardSwipe()
        SoundManager.shared.playCardSwipe()
    }
    
    func playFavoriteWithSound(isFavorited: Bool) {
        playFavoriteToggle(isFavorited: isFavorited)
        if isFavorited {
            SoundManager.shared.playFavoriteAdd()
        } else {
            SoundManager.shared.playFavoriteRemove()
        }
    }
    
    func playAchievementWithSound() {
        notification(.success)
        SoundManager.shared.playAchievementUnlock()
    }
    
    func playStreakWithSound() {
        playStreak()
        SoundManager.shared.playStreakMilestone()
    }
    
    func playButtonTapWithSound() {
        impact(.light)
        SoundManager.shared.playButtonTap()
    }
}

