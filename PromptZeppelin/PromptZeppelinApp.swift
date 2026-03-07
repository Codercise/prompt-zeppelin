import SwiftUI

@main
struct PromptZeppelinApp: App {
    @StateObject private var transcriptListVM = TranscriptListViewModel()
    @StateObject private var teleprompterVM = TeleprompterViewModel()
    @StateObject private var panelController = FloatingPanelController()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(transcriptListVM)
                .environmentObject(teleprompterVM)
                .environmentObject(panelController)
        }
        .defaultSize(width: 800, height: 600)
    }
}
