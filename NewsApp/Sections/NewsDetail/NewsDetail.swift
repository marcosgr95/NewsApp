import SwiftUI

struct NewsDetail: View {
    @ObservedObject var viewModel: NewsDetailViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                if let url = URL(string: viewModel.news.imageUrl ?? "") {
                    CustomAsyncImageView(url: url)
                } else {
                    Spacer()
                        .frame(height: 80)
                }

                VStack(spacing: 15) {
                    Text(viewModel.news.title)
                        .latoFont(textStyle: .title, weight: .bold)
                        .frame(maxWidth: .infinity, alignment: .center)

                    if let source = viewModel.news.source?.name {
                        Text(source)
                            .latoFont(textStyle: .caption2, italics: true)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }

                    if let description = viewModel.news.description {
                        Text(description)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding([.top], 30)
                    }
                }
                .padding([.leading, .trailing, .top], 16)
                .iPadPadding(30)
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .navigationBarHidden(true)
        }
        .floatingButton(
            alignment: .topLeading,
            hidingCondition: UIDevice.current.userInterfaceIdiom == .pad
        ) {
            Image(systemName: "xmark")
        } action: {
            viewModel.pop()
        }
        .floatingButton {
            Image(systemName: "safari")
        } action: {
            viewModel.seeOnSafari()
        }.background(
            LinearGradient(gradient: Gradient(colors: [.secondaryCustom, .secondaryCustom.opacity(0.25)]), startPoint: .bottom, endPoint: .top)
        )
    }
}

#Preview {
    NewsDetail(
        viewModel: NewsDetailViewModel(news: fakeNews, coordinator: FakeCoordinator(), interactor: NewsDetailInteractor())
    )
}
