// A (WIP) desktop shell for macOS akin to what might be found in Linux ricing
// Copyright (C) 2025 Luke Murray

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

import AppKit
import SwiftUI

func color_from_hex(_ hex: Int) -> Color {
    return Color(
      red: Double((hex >> 16) & 0xff) / 255.0,
      green: Double((hex >> 8) & 0xff) / 255.0,
      blue: Double((hex >> 0) & 0xff) / 255.0
    )
}

struct ContentView: View {
    @State var right_tab_open = false

    var body: some View {
        ZStack {
            let screen_height = NSScreen.main!.frame.height
            BorderView()
            ClockView()
              .position(x: bar_width / 2, y: screen_height / 20)
            AppleIconView(tab_open: $right_tab_open)
              .position(x: bar_width / 2, y: screen_height * 0.98)
        }
    }
}

@main
struct HelloApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
              .frame(width: NSScreen.main!.frame.width, height: NSScreen.main!.frame.height, alignment: .center)
        }
          .windowResizability(.contentSize)
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApplication.shared.setActivationPolicy(.regular)

        if let window = NSApplication.shared.windows.first {
            window.styleMask = .borderless
            window.isOpaque = false;
            window.backgroundColor = .clear;
        }
    }
}
