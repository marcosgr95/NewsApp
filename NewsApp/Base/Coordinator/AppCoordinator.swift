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
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .frame(width: 350, height: 350)
                    .shadow(color: .secondaryCustom, radius: 5, x: 1.5, y: 1.5)
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
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            self.isDisplayingSplash = false
        }
    }
}
