import SwiftUI

struct APODNavigationView<ViewModel: APODViewModelProtocol>: View where ViewModel: ObservableObject {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        NavigationView {
            APODStateView(viewModel: viewModel)
                .navigationTitle("NASA APOD")
                .toolbar {
                    APODToolbarView(viewModel: viewModel)
                }
        }
    }
}

struct APODToolbarView<ViewModel: APODViewModelProtocol>: ToolbarContent where ViewModel: ObservableObject {
    @ObservedObject var viewModel: ViewModel
    
    var body: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            APODFeaturesButton()
        }
        
        ToolbarItem(placement: .navigationBarTrailing) {
            APODRandomButton(viewModel: viewModel)
        }
    }
}

struct APODFeaturesButton: View {
    var body: some View {
        Button("Features") {
        }
    }
}

struct APODRandomButton<ViewModel: APODViewModelProtocol>: View where ViewModel: ObservableObject {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        Button("Random") {
            viewModel.handle(.loadRandomAPOD)
        }
        .disabled(viewModel.state.isLoading)
    }
}
