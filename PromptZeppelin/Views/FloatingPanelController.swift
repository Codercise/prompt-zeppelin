import AppKit
import SwiftUI

@MainActor
final class FloatingPanelController: ObservableObject {
    @Published var isShowing = false
    private var panel: NSPanel?

    func show(viewModel: TeleprompterViewModel) {
        if panel != nil { close() }

        let overlayView = TeleprompterOverlayView(viewModel: viewModel)
        let hostingView = NSHostingView(rootView: overlayView)

        let screen = NSScreen.main ?? NSScreen.screens.first!
        let screenFrame = screen.visibleFrame

        let panelWidth: CGFloat = screenFrame.width * 0.6
        let panelHeight: CGFloat = 100

        let x = screenFrame.midX - panelWidth / 2
        let y = screenFrame.maxY - panelHeight - 10

        let panel = NSPanel(
            contentRect: NSRect(x: x, y: y, width: panelWidth, height: panelHeight),
            styleMask: [.titled, .resizable, .nonactivatingPanel, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )

        panel.titlebarAppearsTransparent = true
        panel.titleVisibility = .hidden
        panel.level = .floating
        panel.isMovableByWindowBackground = true
        panel.isOpaque = false
        panel.backgroundColor = .clear
        panel.hasShadow = false
        panel.hidesOnDeactivate = false
        panel.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary, .transient]
        panel.minSize = NSSize(width: 300, height: 60)
        panel.contentView = hostingView

        panel.orderFrontRegardless()

        self.panel = panel
        self.isShowing = true
    }

    func close() {
        panel?.close()
        panel = nil
        isShowing = false
    }
}
