import SwiftUI

extension View {
    func onNavigation(_ action: @escaping () -> Void) -> some View {
        let isNavigationActive = Binding {
            false
        } set: {
            if $0 { action() }
        }

        return ZStack {
            NavigationLink(destination: EmptyView(), isActive: isNavigationActive) {
                EmptyView()
            }
            .frame(width: 0)
            .opacity(0)
            self
        }
    }

    func navigation<ViewModel, Destination: View>(
        viewModel: Binding<ViewModel?>,
        @ViewBuilder destination: @escaping (ViewModel) -> Destination
    ) -> some View {
        let isActive = Binding(
            get: { viewModel.wrappedValue != nil },
            set: { value in
                if !value {
                    viewModel.wrappedValue = nil
                }
            }
        )
        return navigation(isActive: isActive) {
            viewModel.wrappedValue.map(destination)
        }
    }

    func navigation<Destination: View>(
        isActive: Binding<Bool>,
        @ViewBuilder destination: @escaping () -> Destination
    ) -> some View {
        if UIDevice.current.userInterfaceIdiom == .pad {
            AnyView(
                overlay(alignment: .center) {
                    NavigationLink(
                        destination: isActive.wrappedValue ? destination() : nil,
                        isActive: isActive,
                        label: { EmptyView() }
                    )
                }
            )
        } else {
            AnyView(
                fullScreenCover(isPresented: isActive) {
                    destination()
                }
            )
        }
    }
}
