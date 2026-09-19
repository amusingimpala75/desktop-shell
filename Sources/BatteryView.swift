import SwiftUI
import IOKit.ps

func getBattery() -> Int? {
    let snapshot = IOPSCopyPowerSourcesInfo()?.takeRetainedValue()
    guard let sources = IOPSCopyPowerSourcesList(snapshot)?.takeRetainedValue() as? [CFTypeRef] else { return nil }
    for ps in sources {
        if let info = IOPSGetPowerSourceDescription(snapshot, ps)?.takeUnretainedValue() as? [String: Any] {
           if let capacity = info[kIOPSCurrentCapacityKey] as? Int,
              let max = info[kIOPSMaxCapacityKey] as? Int {
               return capacity * 100 / max
           }
        }
    }
    return nil
}

func isCharging() -> Bool {
    let snapshot = IOPSCopyPowerSourcesInfo()?.takeRetainedValue()
    guard let sources = IOPSCopyPowerSourcesList(snapshot)?.takeRetainedValue() as? [CFTypeRef] else { return false }
    for ps in sources {
        if let info = IOPSGetPowerSourceDescription(snapshot, ps)?.takeUnretainedValue() as? [String: Any] {
            if let ch = info[kIOPSIsChargingKey] as? Bool {
                return ch
            }
        }
    }
    return false
}


struct PieSlice: Shape {
    var startAngle: Angle
    var endAngle: Angle

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        path.move(to: center)
        path.addArc(
            center: center,
            radius: rect.width / 2,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: false
        )
        path.closeSubpath()
        return path
    }
}

func formatBattery() -> AnyView {
    var ret = PieSlice(startAngle: .degrees(0), endAngle: .degrees(90)).foregroundColor(bg_color)
    if let bat = getBattery() {
        let slice = PieSlice(startAngle: .degrees(0), endAngle: .degrees(360.0 / 100.0 * Double(bat)))
        if isCharging() {
            ret = slice.foregroundColor(charging_color)
        } else if bat <= 20 {
            ret = slice.foregroundColor(low_power_color)
        } else {
            ret = slice.foregroundColor(text_color)
        }
    }
    return AnyView(ret)
}

func batStr() -> Text? {
    if let bat = getBattery() {
        return Text("\(bat)%")
          .font(.custom(font_family, fixedSize: font_size))
          .foregroundColor(bg_color)
    }
    return nil
}

struct BatteryView : View {
    let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()

    @State var battery: AnyView = formatBattery()
    @State var text: Text? = batStr()
    @State var hover: Bool = false

    let width: Double
    let height: Double
    let x: Double
    let y: Double

    var body: some View {
        ZStack {
            // TODO background grey to make text readable
            battery
            if let t = text {
                if hover {
                    t
                }
            }
        }.onReceive(timer) { _ in
            battery = formatBattery()
            text = batStr()
        }.onHover { on in
            hover = on
        }.animation(.easeInOut(duration: 0.25), value: hover)
          .frame(width: hover ? width * 2 : width, height: hover ? height * 1.5 : height)
          .position(x: hover ? x + width * 0.5 : x, y: hover ? y - height * 0.25 : y)
    }
}
