import SwiftUI

struct ContentView: View {
    @EnvironmentObject var listVM: TranscriptListViewModel
    @EnvironmentObject var teleprompterVM: TeleprompterViewModel
    @EnvironmentObject var panelController: FloatingPanelController

    var body: some View {
        NavigationSplitView {
            TranscriptListView()
        } detail: {
            if let selected = listVM.selectedTranscriptId {
                TranscriptEditorView(transcriptId: selected)
                    .id(selected)
            } else {
                VStack(spacing: 12) {
                    Image(systemName: "text.viewfinder")
                        .font(.system(size: 48))
                        .foregroundStyle(.tertiary)
                    Text("Select or create a transcript")
                        .foregroundStyle(.secondary)
                    Button("New Transcript", action: listVM.createTranscript)
                        .buttonStyle(.borderedProminent)
                }
            }
        }
        .frame(minWidth: 700, minHeight: 450)
    }
}
