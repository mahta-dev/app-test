import SwiftUI

struct APODStateView<ViewModel: APODViewModelProtocol>: View where ViewModel: ObservableObject {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        switch viewModel.state {
        case .idle:
            APODWelcomeView {
                viewModel.handle(.loadAPOD(date: "2024-01-01"))
            }
        case .loading:
            APODLoadingView()
        case .success(let apod):
            APODSuccessView(apod: apod)
        case .error(let error):
            APODErrorView(
                error: error,
                onRetry: {
                    viewModel.handle(.loadAPOD(date: "2024-01-01"))
                },
                onDismiss: {
                    viewModel.handle(.clearError)
                }
            )
        }
    }
}
