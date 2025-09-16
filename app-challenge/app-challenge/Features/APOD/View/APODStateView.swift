import SwiftUI

struct APODStateView<ViewModel: APODViewModelProtocol>: View where ViewModel: ObservableObject {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                APODLoadingView()
            } else if let apod = viewModel.apod {
                APODSuccessView(apod: apod)
            } else if let error = viewModel.error {
                APODErrorView(
                    error: error,
                    onRetry: {
                        viewModel.handle(.loadAPOD(date: "2024-01-01"))
                    },
                    onDismiss: {
                        viewModel.handle(.clearError)
                    }
                )
            } else {
                APODWelcomeView {
                    viewModel.handle(.loadAPOD(date: "2024-01-01"))
                }
            }
        }
    }
}
