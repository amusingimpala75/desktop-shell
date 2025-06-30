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

func add_corner(
  position: CGPoint,
  radius: CGFloat,
  color: Color,
  flip_right: Bool = false,
  flip_down: Bool = false
) -> some View {
    var arc_center = position
    var arc_start_angle: CGFloat, arc_end_angle: CGFloat

    if !flip_right {
        arc_center.x += radius
        arc_start_angle = 180
    } else {
        arc_center.x -= radius
        arc_start_angle = 0
    }

    if !flip_down {
        arc_center.y += radius
        arc_end_angle = 270
    } else {
        arc_center.y -= radius
        arc_end_angle = 90
    }

    return Path { path in
        path.move(to: position)
        path.addArc(
          center: arc_center,
          radius: radius,
          startAngle: .degrees(arc_start_angle),
          endAngle: .degrees(arc_end_angle),
          clockwise: flip_right != flip_down
        )
        path.addLine(to: position)
    }.fill(color)
}

func add_rect(
  position: CGPoint,
  width: CGFloat,
  height: CGFloat,
  color: Color
) -> some View {
    let center = CGPoint(
      x: position.x + width / 2,
      y: position.y + height / 2
    )
    return Rectangle()
      .fill(color)
      .frame(width: width, height: height)
      .position(center)
}

struct BorderView : View {
    var body: some View {
        GeometryReader { geometry in
            let screen_height = NSScreen.main!.frame.height
            let screen_width = NSScreen.main!.frame.width

            // Sides
            // Left (bar)
            add_rect(
              position: CGPoint(x: 0, y: 0),
              width: bar_width,
              height: screen_height,
              color: bg_color
            )
            // Top
            add_rect(
              position: CGPoint(x: bar_width, y: 0),
              width: screen_width - bar_width,
              height: screen_padding,
              color: bg_color
            )
            // Bottom
            add_rect(
              position: CGPoint(
                x: bar_width,
                y: screen_height - screen_padding
              ),
              width: screen_width - bar_width,
              height: screen_padding,
              color: bg_color
            )
            // Right
            add_rect(
              position: CGPoint(
                x: screen_width - screen_padding,
                y: screen_padding
              ),
              width: screen_padding,
              height: screen_height - 2 * screen_padding,
              color: bg_color
            )

            // Corners
            // Top Left
            add_corner(
              position: CGPoint(
                x: bar_width,
                y: screen_padding
              ),
              radius: corner_radius,
              color: bg_color
            )
            // Top Right
            add_corner(
              position: CGPoint(
                x: screen_width - screen_padding,
                y: screen_padding
              ),
              radius: corner_radius,
              color: bg_color,
              flip_right: true
            )
            // Bottom Right
            add_corner(
              position: CGPoint(
                x: screen_width - screen_padding,
                y: screen_height - screen_padding
              ),
              radius: corner_radius,
              color: bg_color,
              flip_right: true,
              flip_down: true
            )
            // Bottom Left
            add_corner(
              position: CGPoint(
                x: bar_width,
                y: screen_height - screen_padding
              ),
              radius: corner_radius,
              color: bg_color,
              flip_down: true
            )
        }
    }
}
