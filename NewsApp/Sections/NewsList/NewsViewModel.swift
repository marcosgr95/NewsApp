import Foundation
import Combine

class NewsViewModel: BaseViewModel {
    let netClient: NetworkService
    let coordinator: AppCoordinator
    let interactor: NewsInteractor

    private var cancellables: Set<AnyCancellable> = []
    private var page: Int = 0

    @Published var news: [NewsModel] = []
    @Published var isLoading: Bool = true
    @Published var isLastPage: Bool = false

    init(netClient: NetworkService, coordinator: AppCoordinator) {
        self.netClient = netClient
        self.coordinator = coordinator
        self.interactor = NewsInteractor(netClient: netClient)
    }

    private func requestTopNews(searchText: String? = nil) {
        isLoading = true

        let newsQuery = NewsQuery(page: page, searchText: searchText)
        interactor.getTopNews(newsQuery)
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                defer { self?.isLoading = false }

                switch completion {
                case .failure(let netError): print("failure \(netError)")
                default: break
                }
            } receiveValue: { [weak self] in
                guard let self else { return }

                self.isLastPage = $0.count < newsQuery.pageSize
                self.news += $0
                self.isLoading = false
            }
            .store(in: &cancellables)
    }

    func requestNews() {
        page += 1
        requestTopNews()
    }

    func requestNewsByText(_ searchText: String) {
        page = 1
        news = []
        requestTopNews(searchText: searchText)
    }

    func isLastIndex(_ index: Int) -> Bool {
        index == news.count - 1
    }

    func navigateToNewsDetail(news: NewsModel) {
        DispatchQueue.main.async { [weak self] in self?.coordinator.navigateToNewsDetail(news: news) }
    }

}
