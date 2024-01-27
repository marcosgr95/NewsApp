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
