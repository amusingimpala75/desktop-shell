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

let external_padding = 8.0
let left_padding = 4 * external_padding;

let bg_color = color_from_hex(0x282828)
let text_color = color_from_hex(0xebdbb2)

func color_from_hex(_ hex: Int) -> Color {
     return Color(
         red: Double((hex >> 16) & 0xff) / 255.0,
         green: Double((hex >> 8) & 0xff) / 255.0,
         blue: Double((hex >> 0) & 0xff) / 255.0
     )
}

func add_corner(bottom: Bool = false, right: Bool = false) -> _ShapeView<Path, Color> {
     var start_horiz = left_padding // 0.0
     var start_vert = 0.0
     var vstep = external_padding
     var hstep = external_padding

     var start_angle = 180.0
     var end_angle = 270.0
     let clockwise = bottom != right

     if bottom {
         vstep = -vstep
         start_vert = NSScreen.main!.frame.height
         end_angle = 90.0
     }

     if right {
         hstep = -hstep
         start_horiz = NSScreen.main!.frame.width
         start_angle = 0.0
     }

     return Path { path in
         path.move(to: CGPoint(x: start_horiz, y: start_vert))
         path.addLine(to: CGPoint(x: start_horiz, y: start_vert + 2 * vstep))
         path.addArc(
             center: CGPoint(x: start_horiz + hstep * 2, y: start_vert + vstep * 2),
             radius: external_padding,
             startAngle: .degrees(start_angle),
             endAngle: .degrees(end_angle),
             clockwise: clockwise
         )
         path.addLine(to: CGPoint(x: start_horiz + 2 * hstep, y: start_vert))
         path.addLine(to: CGPoint(x: start_horiz, y: start_vert))
     }.fill(bg_color)
}

func add_edge(vertical: Bool = false, opposite: Bool = false) -> _ShapeView<Path, Color> {
    var start_horiz = 2 * external_padding
    var end_horiz = NSScreen.main!.frame.width - 2 * external_padding
    var start_vert = 0.0
    var end_vert = external_padding

    if vertical {
        start_horiz = 0.0
        end_horiz = external_padding
        start_vert = 2 * external_padding
        end_vert = NSScreen.main!.frame.height - 2 * external_padding
    }

    if opposite {
        if vertical {
            end_horiz = NSScreen.main!.frame.width
            start_horiz = end_horiz - external_padding
        } else {
            end_vert = NSScreen.main!.frame.height
            start_vert = end_vert - external_padding
        }
    }

    if vertical && !opposite {
        end_horiz = left_padding + external_padding
        start_vert = 0.0
        end_vert += 2 * external_padding
    }

    return Path { path in
        path.move(to: CGPoint(x: start_horiz, y: start_vert))
        path.addLine(to: CGPoint(x: start_horiz, y: end_vert))
        path.addLine(to: CGPoint(x: end_horiz, y: end_vert))
        path.addLine(to: CGPoint(x: end_horiz, y: start_vert))
        path.addLine(to: CGPoint(x: start_horiz, y: start_vert))
    }.fill(bg_color)
}

struct ContentView: View {
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                add_corner()
                add_corner(right: true)
                add_corner(bottom: true)
                add_corner(bottom: true, right: true)
                add_edge()
                add_edge(vertical: true)
                add_edge(opposite: true)
                add_edge(vertical: true, opposite: true)
            }
            ClockView()
                .position(x: 2 * external_padding, y: 4 * external_padding)
        }
    }
}

struct ClockView : View {
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    let cal = Calendar.current

    @State var hour: NSInteger = 0
    @State var minute: NSInteger = 0
    @State var second: NSInteger = 0

    var body: some View {
        HStack {
            let hourString = String(format: "%02d", hour)
            let minuteString = String(format: "%02d", minute)
            let secondString = String(format: "%02d", second)
            Text("\(hourString)\n\(minuteString)\n\(secondString)")
                .font(.custom("Iosevka", fixedSize: 16))
                .foregroundColor(text_color)
                .onHover { hover in
                    print("Mouse hover: \(hover)")
                }
        }
        .onReceive(timer) { time in
            hour = cal.component(.hour, from: time)
            minute = cal.component(.minute, from: time)
            second = cal.component(.second, from: time)
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