import AppKit
import SwiftUI

@MainActor
final class FloatingPanelController: ObservableObject {
    @Published var isShowing = false
    private var panel: NSPanel?

    private var eventMonitor: Any?

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

        panel.standardWindowButton(.closeButton)?.isHidden = true
        panel.standardWindowButton(.miniaturizeButton)?.isHidden = true
        panel.standardWindowButton(.zoomButton)?.isHidden = true

        panel.ignoresMouseEvents = true

        let monitorHandler: (NSEvent) -> Void = { [weak panel] event in
            panel?.ignoresMouseEvents = !event.modifierFlags.contains(.shift)
        }

        let localMonitor = NSEvent.addLocalMonitorForEvents(matching: .flagsChanged) { event in
            monitorHandler(event)
            return event
        }
        
        let globalMonitor = NSEvent.addGlobalMonitorForEvents(matching: .flagsChanged) { event in
            monitorHandler(event)
        }

        eventMonitor = [localMonitor as Any, globalMonitor as Any]

        panel.orderFrontRegardless()

        self.panel = panel
        self.isShowing = true
    }

    func close() {
        if let monitors = eventMonitor as? [Any] {
            for monitor in monitors {
                NSEvent.removeMonitor(monitor)
            }
            eventMonitor = nil
        }
        panel?.close()
        panel = nil
        isShowing = false
    }
}
