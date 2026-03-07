import Foundation

final class TranscriptStore {
    private let directory: URL

    init() {
        let appSupport = FileManager.default.urls(
            for: .applicationSupportDirectory,
            in: .userDomainMask
        ).first!
        directory = appSupport
            .appendingPathComponent("PromptZeppelin", isDirectory: true)
            .appendingPathComponent("transcripts", isDirectory: true)
        try? FileManager.default.createDirectory(
            at: directory,
            withIntermediateDirectories: true
        )
    }

    func loadAll() -> [Transcript] {
        guard let files = try? FileManager.default.contentsOfDirectory(
            at: directory,
            includingPropertiesForKeys: nil
        ) else { return [] }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        return files.compactMap { url in
            guard url.pathExtension == "json",
                  let data = try? Data(contentsOf: url),
                  let transcript = try? decoder.decode(Transcript.self, from: data)
            else { return nil }
            return transcript
        }.sorted { $0.updatedAt > $1.updatedAt }
    }

    func save(_ transcript: Transcript) {
        let url = directory.appendingPathComponent("\(transcript.id.uuidString).json")
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = .prettyPrinted
        guard let data = try? encoder.encode(transcript) else { return }
        try? data.write(to: url)
    }

    func delete(_ transcript: Transcript) {
        let url = directory.appendingPathComponent("\(transcript.id.uuidString).json")
        try? FileManager.default.removeItem(at: url)
    }
}
