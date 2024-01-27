import SwiftUI

struct SearchField: View {
    @Binding var searchText: String

    var body: some View {
        VStack {
            HStack(spacing: 20) {
                Image(systemName: "magnifyingglass")
                TextField("Search", text: $searchText)
                    .foregroundStyle(.secondaryCustom)
                    .font(Font.body.weight(.heavy))
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
    SearchField(searchText: .constant("Searching..."))
}
