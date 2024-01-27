import SwiftUI

struct GettingMoreItemsView: View {
    let action: () -> Void

    @State var isAnimating = false

    var body: some View {
        HStack {
            Spacer()
            Text("Getting more...")
            Image(systemName: "arrow.down.circle.fill")
                .foregroundStyle(Color.primary.opacity(self.isAnimating ? 0.1 : 1))
                .scaleEffect(self.isAnimating ? 0.5: 1)
                .animation(isAnimating ? Animation.easeInOut(duration: 0.7).repeatForever(autoreverses: true) : .default, value: isAnimating)
                .afterLoading {
                    self.isAnimating = true
                    action()
                }
            Spacer()
        }
    }
}

#Preview {
    GettingMoreItemsView(action: {})
}