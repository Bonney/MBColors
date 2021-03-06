//
//  File.swift
//  
//
//  Created by Matt Bonney on 7/14/22.
//

import SwiftUI

/// A SwiftUI Color, annotated with a display name String.
///
/// - Parameters:
///     - name: the display name for the color
///     - color: a SwiftUI Color
///
public struct LabeledColor: Identifiable {
    public let id: UUID
    var name: String
    var color: Color

    /// A SwiftUI Label, where the Title is this LabeledColor's Name,
    /// and the Icon is a circle in this LabeledColor's Color.
    @ViewBuilder var label: some View {
        Label {
            Text(name.capitalized)
        } icon: {
            Image(systemName: "circle")
                .symbolVariant(.fill)
                .foregroundStyle(color)
        }
    }

    init(_ name: String, color: Color) {
        self.id = UUID()
        self.name = name
        self.color = color
    }
}

public extension LabeledColor {
    init(_ name: String, hex: String) {
        self.init(name, color: Color(hex: hex))
    }
}

