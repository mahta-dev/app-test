import SwiftUI

struct URLShortenerStateView<ViewModel: URLShortenerViewModelProtocol>: View where ViewModel: ObservableObject {
    @ObservedObject var viewModel: ViewModel
    @State private var detailViewModel: URLShortenerDetailViewModel?
    
    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                URLShortenerInputView(viewModel: viewModel)
                
                switch viewModel.state {
                case .idle:
                    URLShortenerWelcomeView {
                        viewModel.handle(.loadShortenedURLs)
                    }
                case .loading:
                    URLShortenerLoadingView()
                case .success(let urls):
                    URLShortenerListView(
                        urls: urls,
                        onDelete: { id in
                            viewModel.handle(.deleteURL(id))
                        },
                        viewModel: detailViewModel ?? createDetailViewModel()
                    )
                case .error(let error):
                    URLShortenerErrorView(
                        error: error,
                        onRetry: {
                            if let retryAction = error.retryAction {
                                retryAction()
                            }
                        },
                        onDismiss: {
                            viewModel.handle(.clearError)
                        }
                    )
                }
            }
        }
        .onTapGesture {
            hideKeyboard()
        }
        .onAppear {
            viewModel.handle(.loadShortenedURLs)
        }
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    private func createDetailViewModel() -> URLShortenerDetailViewModel {
        let useCase = URLShortenerUseCase(
            repository: URLShortenerRepository(
                dataSource: URLShortenerRemoteDataSource()
            )
        )
        let detailVM = URLShortenerDetailViewModel(useCase: useCase)
        detailViewModel = detailVM
        return detailVM
    }
}
