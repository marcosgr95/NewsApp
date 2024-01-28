import SwiftUI

struct NewsList: View {
    @ObservedObject var viewModel: NewsViewModel

    @State private var searchText = ""
    @FocusState private var isTextFocused: Bool

    var body: some View {
            VStack(spacing: 0) {

                HStack {
                    Image(.splash)
                        .resizable()
                        .scaledToFit()
                        .clipShape(Circle())
                        .frame(width: 60, height: 60, alignment: .leading)

                    SearchField(searchText: $searchText) {
                        viewModel.requestNewsByText(searchText)
                    }
                    .focused($isTextFocused)
                    .onSubmit {
                        isTextFocused = false
                    }
                }
                .background(.mainCustom)

                if viewModel.isLoading, viewModel.news.isEmpty {
                    VStack {
                        Spacer()
                        LoadingView()
                            .afterLoading {
//                                try? await Task.sleep(nanoseconds: 500_000_000)
                                viewModel.requestNews()
                            }
                        Spacer()
                    }
                } else {
                    List {
                        ForEach(viewModel.news.enumerated().map { $0 }, id: \.element.id) { index, news in
                            VStack {
                                NewsCell(
                                    onNavigation: { viewModel.navigateToNewsDetail(news: news) },
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
                        .clearContentBackground() // TODO: Is this necessary?
                        .listRowInsets(EdgeInsets(top: 8.0, leading: 8.0, bottom: 8.0, trailing: 8.0))
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                    }
                    .hideScrollIndicator()
                }
            }
            .clearContentBackground()
    }
}

#Preview {
    let netClient = NewsAppClient()
    return NewsList(viewModel: NewsViewModel(netClient: netClient, coordinator: AppCoordinator(netClient: netClient)))
}
