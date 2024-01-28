import SwiftUI

struct OnAppear: ViewModifier {
    let action: () async -> Void
    func body(content: Content) -> some View {
        content
            .onAppear {
                Task {
                    await action()
                }
            }
    }
}

extension View {
    func afterLoading(action: @escaping () async -> Void) -> some View {
        modifier(OnAppear(action: action))
    }
}

@available(iOS 16.0, *)
struct ClearContentBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .scrollContentBackground(.hidden)
    }
}

extension View {
    @ViewBuilder
    func clearContentBackground() -> some View {
        if #available(iOS 16.0, *) {
            modifier(ClearContentBackground())
        } else {
            self
        }
    }
}

@available(iOS 16.0, *)
struct NoScrollIndicator: ViewModifier {
    func body(content: Content) -> some View {
        content
            .scrollIndicators(.hidden)
    }
}

extension View {
    @ViewBuilder
    func hideScrollIndicator() -> some View {
        if #available(iOS 16.0, *) {
            modifier(NoScrollIndicator())
        } else {
            self
        }
    }
}

struct FloatingButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 1.5 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct FloatingButton<T: View, FG: ShapeStyle, BG: View>: ViewModifier {
    let alignment: Alignment
    let label: () -> T
    let action: () -> Void
    let foregroundStyle: () -> FG
    let background: () -> BG

    func body(content: Content) -> some View {
        ZStack(alignment: alignment) {
            content

            Button(action: action, label: label)
                .padding()
                .foregroundStyle(foregroundStyle())
                .background(background())
                .clipShape(Circle())
                .shadow(color: (foregroundStyle() as? Color) ?? .secondary, radius: 5, x: 1.5, y: 1.5)
                .buttonStyle(FloatingButtonStyle())
                .padding(12)
        }
    }
}

extension View {
    func floatingButton<T: View, FG: ShapeStyle, BG: View>(
        alignment: Alignment = .bottomTrailing,
        label: @escaping () -> T,
        action: @escaping () -> Void,
        foregroundStyle: @escaping () -> FG = { Color.mainCustom },
        background: @escaping () -> BG = { Color.secondaryCustom }
    ) -> some View {
        modifier(FloatingButton(alignment: alignment, label: label, action: action, foregroundStyle: foregroundStyle, background: background))
    }
}

struct CustomFont: ViewModifier {
    let textStyle: Font.TextStyle
    let weight: Font.Weight
    let italics: Bool

    private var fontName: String {
        if weight == .bold {
            "Lato-Bold\(italics ? "Italic" : "")"
        } else {
            "Lato-\(italics ? "Italic" : "Regular")"
        }
    }

    func body(content: Content) -> some View {
        content
            .font(Font.custom(fontName, size: 18, relativeTo: textStyle))
    }
}

extension View {
    func latoFont(
        textStyle: Font.TextStyle = .body,
        weight: Font.Weight = .regular,
        italics: Bool = false
    ) -> some View {
        modifier(CustomFont(textStyle: textStyle, weight: weight, italics: italics))
    }
}

struct IPadPadding: ViewModifier {
    let padding: CGFloat

    func body(content: Content) -> some View {
        if UIDevice.current.userInterfaceIdiom == .pad {
            content.padding([.leading, .trailing], padding)
        } else {
            content
        }
    }
}

extension View {
    func iPadPadding(_ padding: CGFloat) -> some View {
        modifier(IPadPadding(padding: padding))
    }
}
