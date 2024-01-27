import SwiftUI

struct NewsList: View {
    @ObservedObject var viewModel: NewsViewModel
    @State private var searchText = ""

    var body: some View {
        if viewModel.isLoading, viewModel.news.isEmpty {
            LoadingView()
                .afterLoading {
                    try? await Task.sleep(nanoseconds: 500_000_000)
                    viewModel.requestNews()
                }
        } else {
            VStack(spacing: 0) {

                HStack {
                    Image(.splash)
                        .resizable()
                        .scaledToFit()
                        .clipShape(Circle())
                        .frame(width: 60, height: 60, alignment: .leading)

                    SearchField(searchText: $searchText)
                }
                .background(.mainCustom)

                List {
                    ForEach(viewModel.news.enumerated().map { $0 }, id: \.element.id) { index, news in
                        VStack {
                            NewsCell(
                                onNavigation: { viewModel.navigateToNewsDetail(news: news)
                                },
                                news: news
                            )

                            if !viewModel.isLastPage, viewModel.isLastIndex(index) {
                                GettingMoreItemsView {
                                    viewModel.requestNews()
                                }
                                .padding([.top], 20)
                            }
                        }
                    }
                    .clearContentBackground()
                    .listRowInsets(EdgeInsets(top: 8.0, leading: 8.0, bottom: 8.0, trailing: 8.0))
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                }
                .hideScrollIndicator()
            }
            .clearContentBackground()
        }
    }
}

#Preview {
    let netClient = NewsAppClient()
    return NewsList(viewModel: NewsViewModel(netClient: netClient, coordinator: AppCoordinator(netClient: netClient)))
}
