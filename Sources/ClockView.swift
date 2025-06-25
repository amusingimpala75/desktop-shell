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

import SwiftUI

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
