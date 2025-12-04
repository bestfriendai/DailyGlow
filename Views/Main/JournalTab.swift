import SwiftUI

// MARK: - Journal Tab - Gratitude & Reflection

struct JournalTab: View {
    @AppStorage("journalEntries") private var journalEntriesData: Data = Data()
    @State private var entries: [JournalEntry] = []
    @State private var showingNewEntry = false
    @State private var selectedEntry: JournalEntry? = nil
    
    var body: some View {
        ZStack {
            // Background
            AnimatedBackground(style: .aurora, showParticles: false)
            
            VStack(spacing: 0) {
                // Header
                headerView
                
                // Stats cards
                statsSection
                    .padding(.top, 16)
                
                // Entries list
                if entries.isEmpty {
                    emptyState
                } else {
                    entriesList
                }
            }
            
            // FAB
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    FloatingActionButton(icon: "plus") {
                        showingNewEntry = true
                        HapticManager.shared.impact(.medium)
                    }
                    .padding(.trailing, 20)
                    .padding(.bottom, 100)
                }
            }
        }
        .sheet(isPresented: $showingNewEntry) {
            NewJournalEntryView(onSave: { entry in
                entries.insert(entry, at: 0)
                saveEntries()
                SoundManager.shared.playSuccess()
            })
        }
        .sheet(item: $selectedEntry) { entry in
            JournalEntryDetailView(entry: entry)
        }
        .onAppear {
            loadEntries()
        }
    }
    
    // MARK: - Header
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Journal")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.textPrimary)
                
                Text("Reflect & grow")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.textTertiary)
            }
            
            Spacer()
            
            Image(systemName: "book.fill")
                .font(.system(size: 28))
                .foregroundColor(.glowTeal)
                .shadow(color: .glowTeal.opacity(0.5), radius: 10)
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
    }
    
    // MARK: - Stats Section
    
    private var statsSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                StatCard(
                    title: "Total Entries",
                    value: "\(entries.count)",
                    icon: "doc.text.fill",
                    color: .glowPurple
                )
                
                StatCard(
                    title: "This Week",
                    value: "\(entriesThisWeek)",
                    icon: "calendar",
                    color: .glowTeal
                )
                
                StatCard(
                    title: "Gratitudes",
                    value: "\(totalGratitudes)",
                    icon: "heart.fill",
                    color: .glowCoral
                )
            }
            .padding(.horizontal, 20)
        }
    }
    
    private var entriesThisWeek: Int {
        let weekAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        return entries.filter { $0.date > weekAgo }.count
    }
    
    private var totalGratitudes: Int {
        entries.reduce(0) { $0 + $1.gratitude.filter { !$0.isEmpty }.count }
    }
    
    // MARK: - Entries List
    
    private var entriesList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(entries) { entry in
                    JournalEntryCard(entry: entry) {
                        selectedEntry = entry
                    }
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
                
                Image(systemName: "pencil.line")
                    .font(.system(size: 40))
                    .foregroundColor(.textTertiary)
            }
            
            VStack(spacing: 8) {
                Text("Start your journal")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.textPrimary)
                
                Text("Tap + to write your first entry\nand track your gratitude journey")
                    .font(.system(size: 16))
                    .foregroundColor(.textTertiary)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
            Spacer()
        }
    }
    
    // MARK: - Data Persistence
    
    private func loadEntries() {
        if let decoded = try? JSONDecoder().decode([JournalEntry].self, from: journalEntriesData) {
            entries = decoded
        }
    }
    
    private func saveEntries() {
        if let encoded = try? JSONEncoder().encode(entries) {
            journalEntriesData = encoded
        }
    }
}

// MARK: - Using JournalEntry from UserPreferences.swift

// MARK: - Stat Card

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(color)
                
                Spacer()
            }
            
            Text(value)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.textPrimary)
            
            Text(title)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.textTertiary)
        }
        .padding(16)
        .frame(width: 130)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.cardDark)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(color.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

// MARK: - Journal Entry Card

struct JournalEntryCard: View {
    let entry: JournalEntry
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    // Date
                    Text(entry.date, style: .date)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.glowGold)
                    
                    Spacer()
                    
                    // Mood
                    if let mood = entry.mood {
                        Text(mood.rawValue)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.textSecondary)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(
                                Capsule()
                                    .fill(Color.white.opacity(0.1))
                            )
                    }
                }
                
                // Content preview
                if !entry.content.isEmpty {
                    Text(entry.content)
                        .font(.system(size: 15))
                        .foregroundColor(.textSecondary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }
                
                // Gratitudes preview
                let filledGratitudes = entry.gratitude.filter { !$0.isEmpty }
                if !filledGratitudes.isEmpty {
                    HStack(spacing: 4) {
                        Image(systemName: "heart.fill")
                            .font(.system(size: 12))
                            .foregroundColor(.red.opacity(0.8))
                        
                        Text("\(filledGratitudes.count) gratitudes")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.textTertiary)
                    }
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.cardDark)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.cardBorder, lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - New Entry View

struct NewJournalEntryView: View {
    @Environment(\.dismiss) var dismiss
    @State private var content: String = ""
    @State private var selectedMood: Mood? = nil
    @State private var gratitude1: String = ""
    @State private var gratitude2: String = ""
    @State private var gratitude3: String = ""
    let onSave: (JournalEntry) -> Void
    
    var body: some View {
        ZStack {
            // Background
            DarkBackground()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    HStack {
                        Button("Cancel") {
                            dismiss()
                        }
                        .foregroundColor(.textSecondary)
                        
                        Spacer()
                        
                        Text("New Entry")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.textPrimary)
                        
                        Spacer()
                        
                        Button("Save") {
                            let gratitudes = [gratitude1, gratitude2, gratitude3].filter { !$0.isEmpty }
                            let entry = JournalEntry(
                                content: content,
                                mood: selectedMood,
                                gratitude: gratitudes
                            )
                            onSave(entry)
                            dismiss()
                        }
                        .foregroundColor(.glowGold)
                        .fontWeight(.semibold)
                    }
                    .padding(.top, 20)
                    
                    // Mood selector
                    VStack(alignment: .leading, spacing: 12) {
                        Text("How are you feeling?")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.textPrimary)
                        
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 10) {
                            ForEach(Mood.allCases, id: \.self) { mood in
                                Button {
                                    selectedMood = mood
                                } label: {
                                    HStack(spacing: 4) {
                                        Image(systemName: mood.icon)
                                            .font(.system(size: 12))
                                        Text(mood.rawValue)
                                            .font(.system(size: 14, weight: .medium))
                                    }
                                    .foregroundColor(selectedMood == mood ? .black : .textPrimary)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 10)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(selectedMood == mood ? Color.glowGold : Color.cardDark)
                                    )
                                }
                            }
                        }
                    }
                    
                    // What's on your mind
                    VStack(alignment: .leading, spacing: 12) {
                        Text("What's on your mind?")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.textPrimary)
                        
                        TextEditor(text: $content)
                            .font(.system(size: 16))
                            .foregroundColor(.textPrimary)
                            .scrollContentBackground(.hidden)
                            .frame(minHeight: 120)
                            .padding(12)
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(Color.cardDark)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 14)
                                            .stroke(Color.cardBorder, lineWidth: 1)
                                    )
                            )
                    }
                    
                    // Gratitudes
                    VStack(alignment: .leading, spacing: 12) {
                        Text("What are you grateful for?")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.textPrimary)
                        
                        GratitudeField(text: $gratitude1)
                        GratitudeField(text: $gratitude2)
                        GratitudeField(text: $gratitude3)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
        }
    }
}

struct GratitudeField: View {
    @Binding var text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "heart.fill")
                .font(.system(size: 14))
                .foregroundColor(.red.opacity(0.7))
            
            TextField("I'm grateful for...", text: $text)
                .font(.system(size: 16))
                .foregroundColor(.textPrimary)
                .tint(.glowGold)
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.cardDark)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.cardBorder, lineWidth: 1)
                )
        )
    }
}

// MARK: - Entry Detail View

struct JournalEntryDetailView: View {
    let entry: JournalEntry
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            DarkBackground()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Header
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(entry.date, style: .date)
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.textPrimary)
                            
                            if let mood = entry.mood {
                                Text(mood.rawValue)
                                    .font(.system(size: 16))
                                    .foregroundColor(.textSecondary)
                            }
                        }
                        
                        Spacer()
                        
                        IconButton(icon: "xmark", size: 36, iconSize: 16) {
                            dismiss()
                        }
                    }
                    
                    // Content
                    if !entry.content.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Reflection")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.textTertiary)
                            
                            Text(entry.content)
                                .font(.system(size: 16))
                                .foregroundColor(.textPrimary)
                                .lineSpacing(4)
                        }
                    }
                    
                    // Gratitudes
                    let filledGratitudes = entry.gratitude.filter { !$0.isEmpty }
                    if !filledGratitudes.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Gratitudes")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.textTertiary)
                            
                            ForEach(filledGratitudes, id: \.self) { gratitudeItem in
                                HStack(spacing: 12) {
                                    Image(systemName: "heart.fill")
                                        .font(.system(size: 14))
                                        .foregroundColor(.red)
                                    
                                    Text(gratitudeItem)
                                        .font(.system(size: 16))
                                        .foregroundColor(.textPrimary)
                                }
                            }
                        }
                    }
                }
                .padding(20)
                .padding(.top, 20)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    JournalTab()
}
