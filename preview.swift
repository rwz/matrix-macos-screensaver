#!/usr/bin/swift
// Quick preview app — runs the screensaver view in a regular window
// so you can screen-record it. Usage:
//   swift preview.swift                    # quit with Esc, Cmd+Q, or a mouse click
//   swift preview.swift --duration 20      # auto-quit after 20 seconds

import Cocoa
import ScreenSaver

// Load the screensaver bundle
let bundlePath = "build/Build/Products/Release/MatrixDigitalRain.saver"
guard let bundle = Bundle(path: bundlePath), bundle.load() else {
    print("Error: Build the project first, then run from the project root:")
    print("  xcodebuild -project MatrixDigitalRain.xcodeproj -scheme MatrixDigitalRain -configuration Release -derivedDataPath build build")
    print("  swift preview.swift")
    exit(1)
}

guard let viewClass = bundle.principalClass as? ScreenSaverView.Type else {
    print("Error: Could not load screensaver view class")
    exit(1)
}

/// Borderless windows refuse key status by default, which means they
/// never receive keyboard events. Opt back in so Esc / Cmd+Q work.
final class PreviewWindow: NSWindow {
    override var canBecomeKey: Bool { true }
    override var canBecomeMain: Bool { true }
}

let app = NSApplication.shared
app.setActivationPolicy(.regular)

// Main menu with a Quit item, so Cmd+Q works like in any other app
let mainMenu = NSMenu()
let appMenuItem = NSMenuItem()
mainMenu.addItem(appMenuItem)
let appMenu = NSMenu()
appMenu.addItem(withTitle: "Quit Preview", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
appMenuItem.submenu = appMenu
app.mainMenu = mainMenu

// Esc or a mouse click also quits, like a real screensaver
let escKeyCode: UInt16 = 53
NSEvent.addLocalMonitorForEvents(matching: [.keyDown, .leftMouseDown, .rightMouseDown]) { event in
    if event.type != .keyDown || event.keyCode == escKeyCode {
        NSApplication.shared.terminate(nil)
        return nil
    }
    return event
}

let screen = NSScreen.main!
let window = PreviewWindow(
    contentRect: screen.frame,
    styleMask: [.borderless],
    backing: .buffered,
    defer: false
)
window.level = .normal
window.backgroundColor = .black
window.collectionBehavior = [.fullScreenPrimary]

let saverView = viewClass.init(frame: window.contentView!.bounds, isPreview: false)!
saverView.autoresizingMask = [.width, .height]
window.contentView!.addSubview(saverView)
window.makeKeyAndOrderFront(nil)
window.toggleFullScreen(nil)

saverView.startAnimation()

// Timer to drive animation
Timer.scheduledTimer(withTimeInterval: saverView.animationTimeInterval, repeats: true) { _ in
    saverView.animateOneFrame()
}

// Auto-quit after --duration seconds (if provided)
if let idx = CommandLine.arguments.firstIndex(of: "--duration"),
   idx + 1 < CommandLine.arguments.count,
   let duration = Double(CommandLine.arguments[idx + 1]) {
    Timer.scheduledTimer(withTimeInterval: duration, repeats: false) { _ in
        NSApplication.shared.terminate(nil)
    }
}

app.activate(ignoringOtherApps: true)
app.run()
