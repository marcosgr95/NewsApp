import Foundation
import Combine

final class NewsViewModel: ObservableObject {
    let coordinator: any Coordinator
    let interactor: any NewsInteractorProtocol

    private var cancellables: Set<AnyCancellable> = []
    private var lastRequestByText: AnyCancellable?
    private var page: Int = 0

    private var lastSearch: String = ""
    private let queryTextSubject = PassthroughSubject<Void, Never>()

    @Published var news: [NewsModel] = []
    @Published var isLoading: Bool = true
    @Published var isLastPage: Bool = false
    @Published var requestFailed: Bool = true

    init(coordinator: any Coordinator, interactor: some NewsInteractorProtocol) {
        self.coordinator = coordinator
        self.interactor = interactor
    }

    private func requestTopNews(searchText: String? = nil) {
        isLoading = true
        requestFailed = false

        let newsQuery = NewsQuery(page: page, searchText: searchText)
        interactor.getTopNews(newsQuery)
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                defer { self?.isLoading = false }

                switch completion {
                case .failure:
                    self?.requestFailed = true
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
        guard lastSearch.isEmpty else { return }

        page += 1
        requestTopNews()
    }

    func requestNewsByText(_ searchText: String) {
        isLoading = true
        lastSearch = searchText

        if searchText.isEmpty {
            news = []
            page = 0
            requestNews()
        } else {
            defer { queryTextSubject.send(()) }

            news = []
            page = 1

            lastRequestByText?.cancel()

            lastRequestByText = queryTextSubject
                .debounce(for: .seconds(1.5), scheduler: RunLoop.current)
                .sink { [weak self] _ in
                    self?.requestTopNews(searchText: searchText)
                }

            lastRequestByText?.store(in: &cancellables)
        }
    }

    func isLastIndex(_ index: Int) -> Bool {
        index == news.count - 1
    }

    func navigateToNewsDetail(news: NewsModel) {
        DispatchQueue.main.async { [weak self] in self?.coordinator.navigateToNewsDetail(news: news) }
    }

    func popDetail() {
        DispatchQueue.main.async { [weak self] in self?.coordinator.popDetail() }
    }

}
