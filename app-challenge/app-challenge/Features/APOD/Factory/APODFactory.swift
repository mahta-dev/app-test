import Foundation
import Network

protocol APODFactoryProtocol {
    func createAPODView() -> APODContentView<APODViewModel>
}

final class APODFactory: APODFactoryProtocol {
    func createAPODView() -> APODContentView<APODViewModel> {
        let requestManager = RequestManager()
        let service = APODService(requestManager: requestManager)
        let dataSource = APODRemoteDataSource(service: service)
        let repository = APODRepository(dataSource: dataSource)
        let useCase = APODUseCase(repository: repository)
        let viewModel = APODViewModel(useCase: useCase)
        return APODContentView(viewModel: viewModel)
    }
}
