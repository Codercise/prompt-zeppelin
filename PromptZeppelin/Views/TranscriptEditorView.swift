import SwiftUI

struct TranscriptEditorView: View {
    @EnvironmentObject var listVM: TranscriptListViewModel
    @EnvironmentObject var teleprompterVM: TeleprompterViewModel
    @EnvironmentObject var panelController: FloatingPanelController

    let transcriptId: UUID

    private var transcript: Transcript? {
        listVM.transcripts.first { $0.id == transcriptId }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Title
            TextField("Title", text: listVM.titleBinding(for: transcriptId))
                .textFieldStyle(.plain)
                .font(.title.bold())
                .padding(.horizontal)
                .padding(.top)

            Divider()
                .padding(.vertical, 8)

            // Teleprompter controls
            controlsBar
                .padding(.horizontal)

            Divider()
                .padding(.vertical, 8)

            // Text editor
            TextEditor(text: listVM.bodyBinding(for: transcriptId))
                .font(.body)
                .scrollContentBackground(.hidden)
                .padding(.horizontal, 12)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    @ViewBuilder
    private var controlsBar: some View {
        HStack(spacing: 16) {
            // Teleprompter toggle
            Button {
                if panelController.isShowing {
                    teleprompterVM.stop()
                    panelController.close()
                } else {
                    let body = transcript?.body ?? ""
                    teleprompterVM.load(text: body)
                    panelController.show(viewModel: teleprompterVM)
                }
            } label: {
                Label(
                    panelController.isShowing ? "Close Teleprompter" : "Open Teleprompter",
                    systemImage: panelController.isShowing ? "eye.slash" : "eye"
                )
            }
            .buttonStyle(.borderedProminent)
            .tint(panelController.isShowing ? .red : .accentColor)

            Divider()
                .frame(height: 24)

            // Playback
            HStack(spacing: 8) {
                Button(action: teleprompterVM.togglePlayPause) {
                    Image(systemName: teleprompterVM.isPlaying ? "pause.fill" : "play.fill")
                        .frame(width: 20)
                }
                .keyboardShortcut(.space, modifiers: [])
                .disabled(!panelController.isShowing)

                Button(action: {
                    teleprompterVM.stop()
                }) {
                    Image(systemName: "stop.fill")
                        .frame(width: 20)
                }
                .disabled(!panelController.isShowing)
            }

            Divider()
                .frame(height: 24)

            // Speed
            HStack(spacing: 8) {
                Image(systemName: "gauge.with.dots.needle.33percent")
                    .foregroundStyle(.secondary)
                Slider(value: $teleprompterVM.wordsPerMinute, in: 60...300, step: 10)
                    .frame(width: 120)
                Text("\(Int(teleprompterVM.wordsPerMinute)) WPM")
                    .monospacedDigit()
                    .foregroundStyle(.secondary)
                    .frame(width: 70, alignment: .leading)
            }

            Spacer()

            // Progress
            if panelController.isShowing && teleprompterVM.isLoaded {
                Text(teleprompterVM.progressText)
                    .font(.caption)
                    .monospacedDigit()
                    .foregroundStyle(.secondary)
            }
        }
    }
}
