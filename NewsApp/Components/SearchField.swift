import SwiftUI

struct SearchField: View {
    @Binding var searchText: String
    let onType: () -> Void

    var body: some View {
        VStack {
            HStack(spacing: 20) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondaryCustom)
                TextField("Search", text: $searchText)
                    .latoFont()
                    .foregroundStyle(.secondaryCustom)
                    .font(Font.body.weight(.heavy))
                    .onChange(of: searchText) { _ in
                        onType()
                    }
            }
            .padding(10)
            .border(.secondaryCustom, width: 3.5)
            .clipShape(RoundedRectangle(cornerRadius: 4))
        }
        .padding(8)
        .background(.mainCustom)
    }
}

#Preview {
    SearchField(searchText: .constant("Searching..."), onType: {})
}
