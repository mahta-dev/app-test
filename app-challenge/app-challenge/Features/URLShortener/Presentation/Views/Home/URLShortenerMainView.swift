import SwiftUI

struct URLShortenerMainView<ViewModel: URLShortenerViewModelProtocol>: View where ViewModel: ObservableObject {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        NavigationView {
            URLShortenerStateView(viewModel: viewModel)
                .navigationTitle("Shorten links")
                .navigationBarTitleDisplayMode(.large)
        }
    }
}
