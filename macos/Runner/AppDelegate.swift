import Cocoa
import FlutterMacOS

@main
class AppDelegate: FlutterAppDelegate {
    override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return false // 阻止应用在最后窗口关闭时退出
    }

    override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }

    override func applicationDidBecomeActive(_ notification: Notification) {
        // 点击 Dock 栏应用图标，如果窗口被隐藏，则显示窗口
        if let window = mainFlutterWindow, !window.isVisible {
            window.makeKeyAndOrderFront(nil)
        }
    }
}
