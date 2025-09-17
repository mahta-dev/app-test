import Foundation
import Network

@MainActor
protocol URLShortenerFactoryProtocol {
    func createURLShortenerView() -> URLShortenerMainView<URLShortenerViewModel>
}

final class URLShortenerFactory: URLShortenerFactoryProtocol {
    
    @MainActor
    func createURLShortenerView() -> URLShortenerMainView<URLShortenerViewModel> {
        let dataSource = URLShortenerRemoteDataSource()
        let repository = URLShortenerRepository(dataSource: dataSource)
        let useCase = URLShortenerUseCase(repository: repository)
        let viewModel = URLShortenerViewModel(useCase: useCase)
        
        return URLShortenerMainView(viewModel: viewModel)
    }
}
