import Foundation
@testable import app_challenge

@MainActor
class MockURLShortenerFactory: URLShortenerFactoryProtocol {
    var createURLShortenerViewCalled = false
    
    func createURLShortenerView() -> URLShortenerMainView<URLShortenerViewModel> {
        createURLShortenerViewCalled = true
        
        let dataSource = URLShortenerRemoteDataSource()
        let repository = URLShortenerRepository(dataSource: dataSource)
        let useCase = URLShortenerUseCase(repository: repository)
        let viewModel = URLShortenerViewModel(useCase: useCase)
        
        return URLShortenerMainView(viewModel: viewModel)
    }
}
