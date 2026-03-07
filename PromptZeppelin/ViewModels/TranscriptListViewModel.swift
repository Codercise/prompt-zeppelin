import SwiftUI

@MainActor
final class TranscriptListViewModel: ObservableObject {
    @Published var transcripts: [Transcript] = []
    @Published var selectedTranscriptId: UUID?

    private let store = TranscriptStore()

    var selectedTranscript: Transcript? {
        transcripts.first { $0.id == selectedTranscriptId }
    }

    init() {
        transcripts = store.loadAll()
    }

    func createTranscript() {
        let transcript = Transcript()
        transcripts.insert(transcript, at: 0)
        store.save(transcript)
        selectedTranscriptId = transcript.id
    }

    func deleteTranscript(_ transcript: Transcript) {
        store.delete(transcript)
        transcripts.removeAll { $0.id == transcript.id }
        if selectedTranscriptId == transcript.id {
            selectedTranscriptId = transcripts.first?.id
        }
    }

    func deleteTranscripts(at offsets: IndexSet) {
        for index in offsets {
            store.delete(transcripts[index])
        }
        transcripts.remove(atOffsets: offsets)
    }

    func titleBinding(for id: UUID) -> Binding<String> {
        Binding(
            get: { self.transcripts.first { $0.id == id }?.title ?? "" },
            set: { newValue in
                guard let index = self.transcripts.firstIndex(where: { $0.id == id }) else { return }
                self.transcripts[index].title = newValue
                self.transcripts[index].updatedAt = Date()
                self.store.save(self.transcripts[index])
            }
        )
    }

    func bodyBinding(for id: UUID) -> Binding<String> {
        Binding(
            get: { self.transcripts.first { $0.id == id }?.body ?? "" },
            set: { newValue in
                guard let index = self.transcripts.firstIndex(where: { $0.id == id }) else { return }
                self.transcripts[index].body = newValue
                self.transcripts[index].updatedAt = Date()
                self.store.save(self.transcripts[index])
            }
        )
    }
}
