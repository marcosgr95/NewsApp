import SwiftUI

@MainActor
protocol Coordinator: ObservableObject {
    func navigateToNewsDetail(news: NewsModel)
    func popDetail()
    func isDisplayingADetail() -> Bool
    func seeOnSafari(url: URL)
}

@MainActor
class AppCoordinator: Coordinator {
    private let netClient: NetworkService

    @Published var newsViewModel: NewsViewModel!
    @Published var newsDetailViewModel: NewsDetailViewModel?
    @Published var urlToDisplayViaSafariWebView: URL?

    init(netClient: NetworkService) {
        self.netClient = netClient
        self.newsViewModel = NewsViewModel(
            coordinator: self,
            interactor: NewsInteractor(netClient: netClient)
        )
    }

    func navigateToNewsDetail(news: NewsModel) {
        newsDetailViewModel = NewsDetailViewModel(
            news: news,
            coordinator: self,
            interactor: NewsDetailInteractor()
        )
    }

    func popDetail() {
        newsDetailViewModel = nil
    }

    func isDisplayingADetail() -> Bool {
        newsDetailViewModel != nil
    }

    func seeOnSafari(url: URL) {
        urlToDisplayViaSafariWebView = url
    }

    func popSafariWebView() {
        urlToDisplayViaSafariWebView = nil
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
                                .navigation(viewModel: $coordinator.urlToDisplayViaSafariWebView) {
                                    SafariWebView(url: $0)
                                        .ignoresSafeArea()
                                }
                        }
                }
                .navigationViewStyle(.automatic)
                .latoFont()
            }
        }
        .afterLoading {
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            self.isDisplayingSplash = false
        }
    }
}
