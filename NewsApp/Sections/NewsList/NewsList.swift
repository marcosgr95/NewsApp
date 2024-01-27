import SwiftUI

struct NewsList: View {
    @ObservedObject var viewModel: NewsViewModel

    var body: some View {
        if viewModel.isLoading, viewModel.news.isEmpty {
            LoadingView()
                .afterLoading {
                    try? await Task.sleep(nanoseconds: 500_000_000)
                    viewModel.requestNews()
                }
        } else {
            List {
                ForEach(viewModel.news.enumerated().map { $0 }, id: \.element.id) { index, news in
                    Text(news.title)
                        .onNavigation {
                            viewModel.navigateToNewsDetail(news: news)
                        }

                    if !viewModel.isLastPage, viewModel.isLastIndex(index) {
                        GettingMoreItemsView {
                            viewModel.requestNews()
                        }
                    }
                }
                .padding()
            }
        }
    }
}

#Preview {
    let netClient = NewsAppClient()
    return NewsList(viewModel: NewsViewModel(netClient: netClient, coordinator: AppCoordinator(netClient: netClient)))
        .previewDevice(PreviewDevice(rawValue: "iPhone 15 Pro"))
}

#Preview {
    let netClient = NewsAppClient()
    return NewsList(viewModel: NewsViewModel(netClient: netClient, coordinator: AppCoordinator(netClient: netClient)))
        .previewDevice(PreviewDevice(rawValue: "iPad Pro (11-inch)"))
}
