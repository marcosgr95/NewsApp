import SwiftUI
import Combine

final class NewsDetailViewModel: ObservableObject {
    let coordinator: any Coordinator
    let interactor: NewsDetailInteractorProtocol

    @Published var news: NewsModel

    private var cancellables: Set<AnyCancellable> = []

    init(news: NewsModel, coordinator: any Coordinator, interactor: some NewsDetailInteractorProtocol) {
        self.news = news
        self.coordinator = coordinator
        self.interactor = interactor
    }

    func pop() {
        DispatchQueue.main.async { [weak self] in self?.coordinator.popDetail() }
    }
}
