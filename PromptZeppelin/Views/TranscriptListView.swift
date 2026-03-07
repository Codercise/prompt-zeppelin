import SwiftUI

struct TranscriptListView: View {
    @EnvironmentObject var listVM: TranscriptListViewModel

    var body: some View {
        List(selection: $listVM.selectedTranscriptId) {
            ForEach(listVM.transcripts) { transcript in
                VStack(alignment: .leading, spacing: 2) {
                    Text(transcript.title)
                        .fontWeight(.medium)
                    Text(transcript.updatedAt, style: .relative)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .tag(transcript.id)
                .contextMenu {
                    Button("Delete", role: .destructive) {
                        listVM.deleteTranscript(transcript)
                    }
                }
            }
            .onDelete(perform: listVM.deleteTranscripts)
        }
        .navigationTitle("Transcripts")
        .toolbar {
            ToolbarItem {
                Button(action: listVM.createTranscript) {
                    Label("New Transcript", systemImage: "plus")
                }
            }
        }
    }
}
