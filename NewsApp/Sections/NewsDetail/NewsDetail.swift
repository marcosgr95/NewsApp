import SwiftUI

struct NewsDetail: View {
    @ObservedObject var viewModel: NewsDetailViewModel

    var body: some View {
        Text(viewModel.news.title)
    }
}

#Preview {
    let netClient = NewsAppClient()
    let fakeNews = NewsModel(
        author: "Jason Schreier",
        title: "Video-Game Companies Make Workers Relocate, Then Fire Them",
        source: NewsModel.Source(name: "Bloomberg"),
        description: "Return-to-office policies are mixing with the inherent volatility of the gaming industry with painful results",
        url: "https://www.bloomberg.com/news/newsletters/2024-01-26/video-game-companies-make-workers-relocate-then-fire-them?embedded-checkout=true",
        imageUrl: "https://assets.bwbx.io/images/users/iqjWHBFdfxIU/iORuKt6DWr5Q/v0/-1x-1.jpg"
    )
    return NewsDetail(viewModel: NewsDetailViewModel(news: fakeNews, netClient: netClient, coordinator: AppCoordinator(netClient: netClient)))
}
