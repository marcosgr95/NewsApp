import SwiftUI

struct NewsList: View {
    // TODO: Retrieve netClient from coordinator
    @ObservedObject var viewModel: NewsViewModel = NewsViewModel(netClient: NewsAppClient())

    var body: some View {
        List(viewModel.news) { news in
            Text(news.title)
        }
        .padding()
        .onAppear {
            viewModel.requestTopNews()
        }
    }
}

#Preview {
    NewsList()
}
