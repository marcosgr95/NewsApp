import SwiftUI

struct LoadingView: View {
    @State private var strokeLength = 0.7
    @State private var rotationDegree = 0
    @State private var isAnimating = false

    var body: some View {
        ZStack {
            Circle()
                .trim(from: 0.0, to: strokeLength / 2)
                .stroke(lineWidth: 2.5)
                .animation(Animation.easeIn(duration: 1.75).repeatForever(autoreverses: true), value: isAnimating)
                .frame(width: 40, height: 40)
                .rotationEffect(.init(degrees: Double(rotationDegree)))
                .animation(.linear(duration: 0.8).repeatForever(autoreverses: false), value: isAnimating)
                .foregroundStyle(.secondaryCustom)

            Circle()
                .trim(from: 0.0, to: strokeLength)
                .stroke(
                    LinearGradient(colors: [.secondaryCustom, .secondaryCustom.opacity(0.1)], startPoint: .topLeading, endPoint: .bottomTrailing),
                    style: StrokeStyle(lineWidth: 8.0, lineCap: .round, lineJoin: .round)
                )
                .animation(Animation.easeIn(duration: 1.75).repeatForever(autoreverses: true), value: isAnimating)
                .frame(width: 80, height: 80)
                .rotationEffect(.init(degrees: Double(rotationDegree)))
                .animation(.linear(duration: 1).repeatForever(autoreverses: false), value: isAnimating)
                .onAppear {
                    isAnimating = true
                    rotationDegree += 360
                    strokeLength = 0
                }
        }
    }
}

#Preview {
    LoadingView()
}
