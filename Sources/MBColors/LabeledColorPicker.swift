import SwiftUI

public enum LabeledColorPickerStyle: Int, Equatable {
    case rounded = 0
    case square = 1
}

private struct LabeledColorPickerDetail: View {
    @Environment(\.dismiss) var dismiss

    let style: LabeledColorPickerStyle
    let colorOptions: [LabeledColor]
    let onSelection: (LabeledColor) -> Void

    private let cellHeight: Double = 60.0

    init(colorOptions: [LabeledColor], style: LabeledColorPickerStyle, onSelection: @escaping (LabeledColor) -> Void) {
        self.colorOptions = colorOptions
        self.style = style
        self.onSelection = onSelection
    }

    @State private var filter: String = ""
    private var filteredOptions: [LabeledColor] {
        if filter.isEmpty {
            return colorOptions
        }

        return colorOptions.filter { labeledColor in
            labeledColor.name.localizedCaseInsensitiveContains(filter)
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                LazyVGrid(
                    columns: Array(repeating: GridItem(spacing: style == .rounded ? 8 : 1), count: 3),
                    spacing: style == .rounded ? 8 : 1
                ) {
                    ForEach(filteredOptions) { option in
                        cell(for: option)
                            .onTapGesture {
                                select(option)
                            }
                    }
                }
                .padding(style == .rounded ? 8 : 0)
            }
            .toolbar {
                ToolbarItem {
                    Button {
                        if let random = colorOptions.randomElement() {
                            select(random)
                        }
                    } label: {
                        Label("Random", systemImage: "shuffle")
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss.callAsFunction()
                    }
                }
            }
            .navigationTitle("Pick a Color")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $filter, placement: SearchFieldPlacement.navigationBarDrawer(displayMode: .always), prompt: Text("Filter..."))

        }
    }

    @ViewBuilder func cell(for labeledColor: LabeledColor) -> some View {
        let shape = RoundedRectangle(cornerRadius: (style == .rounded ? 12 : 0), style: .continuous)

        ZStack {
            shape
                .stroke(.tertiary, lineWidth: style == .rounded ? 1 : 0)
            shape
                .foregroundColor(labeledColor.color)
        }
            .frame(height: self.cellHeight)
            .overlay {
                labeledColor.label.labelStyle(.titleOnly)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(labeledColor.contrastingForegroundColor)
            }
    }

    func select(_ labeledColor: LabeledColor) {
        onSelection(labeledColor)
        dismiss.callAsFunction()
    }
}

public struct LabeledColorPicker: View {
    @State private var presentPickerDetail: Bool = false

    @Binding public var selected: LabeledColor
    let style: LabeledColorPickerStyle
    public let colorOptions: [LabeledColor]

    public init(selected: Binding<LabeledColor>, style: LabeledColorPickerStyle, options: [LabeledColor]) {
        self._selected = selected
        self.style = style
        self.colorOptions = options
    }

    public var body: some View {
        Button {
            print("toggling")
            presentPickerDetail.toggle()
        } label: {
            LabeledContent {
                Image(systemName: "chevron.up.chevron.down")
            } label: {
                selected.label
            }
        }
        .buttonStyle(.plain)
        .foregroundStyle(.primary)
        .sheet(isPresented: $presentPickerDetail) {
            if #available(iOS 16.4, *) {
                LabeledColorPickerDetail(colorOptions: self.colorOptions, style: style) { selection in
                    self.selected = selection
                }
                .presentationDetents([.medium, .large])
                .presentationContentInteraction(.scrolls)
            } else {
                LabeledColorPickerDetail(colorOptions: self.colorOptions, style: style) { selection in
                    self.selected = selection
                }
                .presentationDetents([.medium, .large])
            }
        }
    }
}

private struct LabeledColorPicker_Demo: View {
    @State private var selected: LabeledColor = LabeledColor.malachite

    var body: some View {
        Form {
            LabeledColorPicker(selected: $selected, style: .square, options: LabeledColorSet.allColorSets)
        }
    }
}

struct LabeledColorPicker_Previews: PreviewProvider {
    static var previews: some View {
        LabeledColorPickerDetail(colorOptions: LabeledColorSet.allColorSets, style: .rounded, onSelection: { _ in })
        LabeledColorPicker_Demo()
    }
}
