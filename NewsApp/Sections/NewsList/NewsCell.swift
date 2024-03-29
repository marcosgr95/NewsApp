import SwiftUI

struct NewsCell: View {
    let onNavigation: () -> Void
    let news: NewsModel

    var body: some View {
        VStack {
            if let url = URL(string: news.imageUrl ?? "") {
                CustomAsyncImageView(url: url)
            }

            Text(news.title)
                .frame(maxWidth: .infinity)
                .padding()

            if let source = news.source?.name {
                Text(source)
                    .latoFont(textStyle: .footnote, italics: true)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding()
            }
        }
        .background(.secondaryCustom)
        .clipShape(RoundedRectangle(cornerRadius: 6))
        .shadow(color: .secondaryCustom, radius: 1, x: 3.0, y: 3.0)
        .onNavigation {
            onNavigation()
        }
    }
}

#Preview {
    NewsCell(onNavigation: { print("Navigated!") }, news: fakeNews)
}
