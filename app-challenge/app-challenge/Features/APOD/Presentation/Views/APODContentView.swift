import SwiftUI

struct APODContentView<ViewModel: APODViewModelProtocol>: View where ViewModel: ObservableObject {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        APODNavigationView(viewModel: viewModel)
    }
}

