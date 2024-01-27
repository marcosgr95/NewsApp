import SwiftUI

@MainActor
class AppCoordinator: ObservableObject {
    private let netClient: NetworkService

    @Published var newsViewModel: NewsViewModel!
    @Published var newsDetailViewModel: NewsDetailViewModel?

    init(netClient: NetworkService) {
        self.netClient = netClient
        self.newsViewModel = NewsViewModel(netClient: netClient, coordinator: self)
    }

    func navigateToNewsDetail(news: NewsModel) {
        self.newsDetailViewModel = NewsDetailViewModel(news: news, netClient: netClient, coordinator: self)
    }
}

struct AppCoordinatorView: View {
    let netClient: NetworkService

    @ObservedObject var coordinator: AppCoordinator

    @State private var isDisplayingSplash: Bool = true
    @State private var isAnimating: Bool = false
    @State private var rotationDegrees: Int = -45

    init(netClient: NetworkService) {
        self.netClient = netClient
        self.coordinator = AppCoordinator(netClient: netClient)
    }

    var body: some View {
        ZStack {
            if isDisplayingSplash {
                Image(.splash)
                    .resizable()
                    .scaledToFit()
                    .clipShape(Circle())
                    .frame(width: 350, height: 350)
                    .rotationEffect(.degrees(Double(rotationDegrees)))
                    .animation(.linear(duration: 0.7).repeatForever(autoreverses: true), value: isAnimating)
                    .onAppear {
                        isAnimating = true
                        rotationDegrees = 45
                    }
            } else {
                NavigationView {
                    NewsList(viewModel: coordinator.newsViewModel)
                        .navigation(viewModel: $coordinator.newsDetailViewModel) { viewModel in
                            NewsDetail(viewModel: viewModel)
                        }
                }
            }
        }
        .afterLoading {
            try? await Task.sleep(nanoseconds: 2_500_000_000)
            withAnimation {
                self.isDisplayingSplash = false
            }
        }
    }
}
