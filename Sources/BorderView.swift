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

struct BorderView : View {
    var body: some View {
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
    }
}