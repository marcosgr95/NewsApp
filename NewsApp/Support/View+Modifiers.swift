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
