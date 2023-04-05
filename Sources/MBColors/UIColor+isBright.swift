import UIKit
import SwiftUI

#if canImport(AppKit) //os(macOS)
import AppKit
typealias UXColor = NSColor
#else
typealias UXColor = UIColor
#endif

public extension UXColor {
    /// Determines if the color is bright or dark based on its overall luminance.
    /// - Returns: `true` if the color is bright, `false` if it is dark.
    func isBright() -> Bool {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        let luminance = (0.2126 * red) + (0.7152 * green) + (0.0722 * blue)
        return luminance > 0.555 // adjusts the "tolerance" of what is considered bright
    }
}

public extension SwiftUI.Color {
    func isBright() -> Bool {
        return UXColor(self).isBright()
    }

    var contrastingForegroundColor: Color {
        self.isBright() ? Color.black : Color.white
    }
}

// MARK: - Previews

struct ColorView: View {
    let color: Color

    var body: some View {
        ZStack {

            self.color
                .frame(height: 80)

            Text(color.isBright() ? "Bright" : "Dark")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .foregroundColor(color.contrastingForegroundColor)
        }
    }
}

struct ColorView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(LabeledColor.gemstones) { labeledColor in
                    ColorView(color: labeledColor.color)
                }
            }
        }
    }
}
