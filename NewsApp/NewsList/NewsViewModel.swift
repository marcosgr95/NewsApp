import Foundation
import Combine

class NewsViewModel: BaseViewModel {
    var netClient: NetworkService
    var interactor: NewsInteractor

    private var cancellables: Set<AnyCancellable> = []
    private var page: Int = 0

    @Published var news: [NewsModel] = []

    init(netClient: NetworkService) {
        self.netClient = netClient
        self.interactor = NewsInteractor(netClient: netClient)
    }

    func requestTopNews() {
        interactor.getTopNews(NewsQuery(page: 1))
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .finished: print("finished")
                case .failure(let netError): print("failure \(netError)")
                }
            } receiveValue: { [weak self] in
                guard let self else { return }
                self.news = $0
            }
            .store(in: &cancellables)
    }

}
