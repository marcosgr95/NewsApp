import SwiftUI

struct NewsCell: View {
    let onNavigation: () -> Void
    let news: NewsModel

    var body: some View {
        VStack {
            if let url = URL(string: news.imageUrl ?? "") {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    ProgressView()
                        .padding()
                }
                .frame(maxWidth: .infinity)
            }

            Text(news.title)
                .foregroundStyle(.secondaryCustom)
                .frame(maxWidth: .infinity)
                .padding()

            if let source = news.source?.name {
                Text(source)
                    .font(.footnote)
                    .foregroundStyle(.secondaryCustom)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding()
            }
        }
        .background(.mainCustom)
        .clipShape(RoundedRectangle(cornerRadius: 6))
        .shadow(color: .secondaryCustom, radius: 3, x: 5.0, y: 5.0)
        .onNavigation {
            onNavigation()
        }
    }
}

#Preview {
    let fakeNews = NewsModel(
        author: "Jason Schreier",
        title: "Video-Game Companies Make Workers Relocate, Then Fire Them",
        source: NewsModel.Source(name: "Bloomberg"),
        description: "Return-to-office policies are mixing with the inherent volatility of the gaming industry with painful results",
        url: "https://www.bloomberg.com/news/newsletters/2024-01-26/video-game-companies-make-workers-relocate-then-fire-them?embedded-checkout=true",
        imageUrl: "https://assets.bwbx.io/images/users/iqjWHBFdfxIU/iORuKt6DWr5Q/v0/-1x-1.jpg"
    )
    return NewsCell(onNavigation: { print("Navigated!") }, news: fakeNews)
}
