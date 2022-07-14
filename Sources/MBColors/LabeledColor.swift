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

