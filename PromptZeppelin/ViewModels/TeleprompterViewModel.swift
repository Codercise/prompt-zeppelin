import SwiftUI
import Combine

struct DisplayWord: Identifiable {
    let id: Int
    let word: String
    let isCurrent: Bool
}

@MainActor
final class TeleprompterViewModel: ObservableObject {
    @Published var words: [String] = []
    @Published var currentWordIndex: Int = 0
    @Published var isPlaying: Bool = false
    @Published var wordsPerMinute: Double = 130
    @Published var visibleWordCount: Int = 5
    @Published var fontSize: Double = 32

    private var timer: Timer?
    private var cancellables = Set<AnyCancellable>()

    var isLoaded: Bool { !words.isEmpty }

    var progress: Double {
        guard !words.isEmpty else { return 0 }
        return Double(currentWordIndex) / Double(words.count - 1)
    }

    var progressText: String {
        "\(currentWordIndex + 1) / \(words.count)"
    }

    var displayWords: [DisplayWord] {
        guard !words.isEmpty else { return [] }
        let halfWindow = visibleWordCount / 2
        let idealStart = currentWordIndex - halfWindow
        let start = max(0, idealStart)
        let end = min(words.count, start + visibleWordCount)
        let adjustedStart = max(0, end - visibleWordCount)

        return (adjustedStart..<end).map { i in
            DisplayWord(id: i, word: words[i], isCurrent: i == currentWordIndex)
        }
    }

    init() {
        $wordsPerMinute
            .dropFirst()
            .sink { [weak self] _ in
                Task { @MainActor in
                    guard let self, self.isPlaying else { return }
                    self.scheduleTimer()
                }
            }
            .store(in: &cancellables)
    }

    func load(text: String) {
        words = text.components(separatedBy: .whitespacesAndNewlines).filter { !$0.isEmpty }
        currentWordIndex = 0
        stop()
    }

    func play() {
        guard !words.isEmpty else { return }
        if currentWordIndex >= words.count - 1 {
            currentWordIndex = 0
        }
        isPlaying = true
        scheduleTimer()
    }

    func pause() {
        isPlaying = false
        timer?.invalidate()
        timer = nil
    }

    func stop() {
        pause()
        currentWordIndex = 0
    }

    func togglePlayPause() {
        if isPlaying {
            pause()
        } else {
            play()
        }
    }

    private func scheduleTimer() {
        timer?.invalidate()
        let interval = 60.0 / wordsPerMinute
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.advance()
            }
        }
    }

    private func advance() {
        if currentWordIndex < words.count - 1 {
            withAnimation(.easeInOut(duration: 0.15)) {
                currentWordIndex += 1
            }
        } else {
            pause()
        }
    }
}
