//
//  Color+.swift
//  MBColorSchemeAccentPicker
//
//  Created by Matt Bonney on 12/21/22.
//

import SwiftUI
import MBUtilities

public extension Color {
    static let sapphire = Color("Sapphire", bundle: Bundle.module)
    static let turquoise = Color("Turquoise", bundle: Bundle.module)
    static let malachite = Color("Malachite", bundle: Bundle.module)
    static let emerald = Color("Emerald", bundle: Bundle.module)
    static let citrine = Color("Citrine", bundle: Bundle.module)
    static let topaz = Color("Topaz", bundle: Bundle.module)
    static let ruby = Color("Ruby", bundle: Bundle.module)
    static let amethyst = Color("Amethyst", bundle: Bundle.module)
    static let lapis = Color("Lapis", bundle: Bundle.module)

    static var gemstoneColors: [Color] {
        [.sapphire, .turquoise, .malachite, .emerald, .citrine, .topaz, .ruby, .amethyst, .lapis]
    }
}

public extension LabeledColor {
    static let sapphire = LabeledColor("Sapphire", color: .sapphire)
    static let turquoise = LabeledColor("Turquoise", color: .turquoise)
    static let malachite = LabeledColor("Malachite", color: .malachite)
    static let emerald = LabeledColor("Emerald", color: .emerald)
    static let citrine = LabeledColor("Citrine", color: .citrine)
    static let topaz = LabeledColor("Topaz", color: .topaz)
    static let ruby = LabeledColor("Ruby", color: .ruby)
    static let amethyst = LabeledColor("Amethyst", color: .amethyst)
    static let lapis = LabeledColor("Lapis", color: .lapis)

    static var gemstones: [LabeledColor] {
        [LabeledColor.sapphire, .turquoise, .malachite, .emerald, .citrine, .topaz, .ruby, .amethyst, .lapis]
    }
}

enum ColorSchemeChoice: Int, Identifiable, Equatable {
    case match = 0
    case light = 1
    case dark = 2

    var id: Int { self.rawValue }
}

struct MBColorSchemeAccentPicker: View {
    @Environment(\.colorScheme) var systemColorScheme

    var colorSchemeToUse: ColorScheme {
        if matchSystem {
            return systemColorScheme
        }

        if colorScheme == .dark {
            return ColorScheme.dark
        }

        return ColorScheme.light
    }

    @State private var accentColor: LabeledColor = LabeledColor.malachite
    @State private var matchSystem: Bool = true
    @State private var colorScheme: ColorSchemeChoice = .match

    let iconSize: Double = 30.0

    var rainbow: some View {
        LinearGradient(colors: Color.gemstoneColors, startPoint: .leading, endPoint: .trailing)
    }

    func smallThemePreview() -> some View {
        Squircle()
            .frame(width: iconSize, height: iconSize)
            .foregroundStyle(.background)
            .overlay {
                Squircle().stroke(.quaternary, lineWidth: 1)
            }
            .overlay(alignment: .center) {
                Circle()
                    .foregroundStyle(accentColor.color.gradient)
                    .frame(width: 12, height: 12)
            }
    }

    var body: some View {
        List {
            Section("Theme") {
                ActionToggle(isOn: $matchSystem) {
                    Text("Match System")
                } action: { newValue in
                    if newValue == true {
                        colorScheme = .match
                    }
                }

                Picker(selection: $colorScheme) {
                    Label {
                        Text("Light")
                    } icon: {
                        smallThemePreview()
                            .environment(\.colorScheme, .light)
                    }
                    .tag(ColorSchemeChoice.light)

                    Label {
                        Text("Dark")
                    } icon: {
                        smallThemePreview()
                            .environment(\.colorScheme, .dark)
                    }
                    .tag(ColorSchemeChoice.dark)
                } label: {
                    Text("Theme")
                }
                .labelsHidden()
                .pickerStyle(.inline)

            }

            Section("Accent") {
                Picker(selection: $accentColor) {
                    ForEach(LabeledColor.gemstones) { labeledColor in
                        Label {
                            Text(labeledColor.name)
                        } icon: {
                            Squircle()
                                .overlay {
                                    Squircle()
                                        .stroke(.background, lineWidth: (accentColor == labeledColor ? 2 : 0))
                                }
                                .frame(width: iconSize, height: iconSize)
                                .shadow(color: labeledColor.color, radius: 2, x: 0, y: 0)
                                .foregroundStyle(labeledColor.color.gradient)
                        }
                        .tag(labeledColor)
                    }
                } label: {
                    Text("Accent Color")
                }
                .pickerStyle(.inline)
                .labelsHidden()
            }

            Section {
                rainbow.listRowInsets(EdgeInsets())
            }
        }
        .preferredColorScheme(colorSchemeToUse)
    }
}

struct MBColorSchemeAccentPicker_Previews: PreviewProvider {
    static var previews: some View {
        MBColorSchemeAccentPicker()
    }
}
