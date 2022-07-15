# MBColors

SwiftUI Color utilities + watchOS-related colors in SwiftUI.

Examples of utilities included:

## SwiftUI Color from HEX

Fairly common, but useful to have around.

```
let ultraviolet = Color(hex: "#7157be")
```

## LabeledColor

A structure that allows giving specfic names to Colors. LabeledColors have two parameters – the name, and the color – as well as a generated Label instance for use in UI.

```
let pacificGreen = LabeledColor("Pacific Green", hex: "#127f9c")

Text(pacificGreen.name)
    .foregroundColor(pacificGreen.color)

```

