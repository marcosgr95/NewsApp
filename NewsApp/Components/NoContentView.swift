import SwiftUI

struct NoContentView: View {
    @State var isAnimating = false
    @State var degrees: Double = -15.0

    var body: some View {
        VStack(alignment: .center, spacing: 15) {
            Text("No results")
                .foregroundStyle(.mainCustom)
                .latoFont(textStyle: .largeTitle, weight: .bold)
            Image(systemName: "exclamationmark.questionmark")
                .foregroundStyle(.mainCustom.opacity(self.isAnimating ? 0.1 : 1))
                .rotationEffect(.degrees(degrees))
                .animation(isAnimating ? Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true) : .default, value: isAnimating)
                .afterLoading {
                    self.isAnimating = true
                    self.degrees += 400
                }
        }
    }
}

#Preview {
    NoContentView()
}
