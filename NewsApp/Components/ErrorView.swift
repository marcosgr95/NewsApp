import SwiftUI

struct ErrorView: View {
    var action: (() -> Void)?

    var body: some View {
        VStack(alignment: .center, spacing: 30) {
            HStack(spacing: 15) {
                Text("Something went wrong")
                    .foregroundStyle(.mainCustom)
                    .latoFont(textStyle: .largeTitle, weight: .bold)
                Image(systemName: "xmark.diamond.fill")
                    .foregroundStyle(.mainCustom)
            }

            Button(
                action: { action?() },
                label: {
                    HStack {
                        Text("Retry")
                            .foregroundStyle(.mainCustom)
                            .latoFont(textStyle: .caption)
                        Image(systemName: "arrow.clockwise")
                            .foregroundStyle(.mainCustom)
                            .rotationEffect(.degrees(45))
                    }
                }
            )
            .opacity(action != nil ? 1 : 0)
        }
    }
}

#Preview {
    ErrorView()
}
