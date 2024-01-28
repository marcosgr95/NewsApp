import SwiftUI

struct CustomAsyncImageView: View {
    let url: URL

    @State private var imageLoaded = false

    var body: some View {
        AsyncImage(
            url: url
        ) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
        } placeholder: {
            ProgressView()
                .padding()
        }
        .onAppear { imageLoaded = true }
        .frame(maxWidth: .infinity)
        .animation(.easeInOut(duration: 0.75), value: imageLoaded)
    }
}

#Preview {
    CustomAsyncImageView(url:
                            URL(string: "https://assets.bwbx.io/images/users/iqjWHBFdfxIU/iORuKt6DWr5Q/v0/-1x-1.jpg") ??
                         URL(string: "www.google.com")!
    )
}
