import SwiftUI

struct AppleIconView : View {
    @Binding var tab_open: Bool

    var body: some View {
        ZStack {
            Circle()
              .fill(mid_color)
              .frame(width: 25, height: 25)
              .offset(x: 0, y: 2)
            Text("")
              .font(.custom(font_family, fixedSize: font_size))
              .foregroundColor(text_color)
        }.onHover { hover in
            withAnimation(.easeInOut(duration: 0.5)) {
                tab_open = hover
            }
        }
    }
}
