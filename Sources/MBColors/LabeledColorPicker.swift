import SwiftUI

private struct LabeledColorPickerDetail: View {
    @Environment(\.dismiss) var dismiss

    let colorOptions: [LabeledColor]
    let onSelection: (LabeledColor) -> Void

    private let columns = Array(repeating: GridItem(.flexible()), count: 3)
    private let cellHeight: Double = 60.0

    init(colorOptions: [LabeledColor], onSelection: @escaping (LabeledColor) -> Void) {
        self.colorOptions = colorOptions
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
                LazyVGrid(columns: columns) {
                    ForEach(filteredOptions) { option in
                        cell(for: option)
                            .onTapGesture {
                                select(option)
                            }
                    }
                }
                .padding(8)
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

    func cell(for labeledColor: LabeledColor) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(.tertiary, lineWidth: 1.0)
            RoundedRectangle(cornerRadius: 12, style: .continuous)
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
    public let colorOptions: [LabeledColor]

    public init(selected: Binding<LabeledColor>, options: [LabeledColor]) {
        self._selected = selected
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
                LabeledColorPickerDetail(colorOptions: self.colorOptions) { selection in
                    self.selected = selection
                }
                .presentationDetents([.medium, .large])
                .presentationContentInteraction(.scrolls)
            } else {
                LabeledColorPickerDetail(colorOptions: self.colorOptions) { selection in
                    self.selected = selection
                }
                .presentationDetents([.medium, .large])
            }
        }
    }
}

private struct LabeledColorPicker_Demo: View {
    @State private var selected: LabeledColor = LabeledColor.malachite
    private let colorOptions = (LabeledColor.gemstones + LabeledColor.watchOSColors)

    var body: some View {
        Form {
            LabeledColorPicker(selected: $selected, options: colorOptions)
        }
    }
}

struct LabeledColorPicker_Previews: PreviewProvider {
    static var previews: some View {
        LabeledColorPicker_Demo()
    }
}
