import Foundation

protocol APODFactoryManagerProtocol {
    func createAPODView() -> APODContentView<APODViewModel>
}

final class APODFactoryManager: APODFactoryManagerProtocol {
    private let factory: APODFactoryProtocol
    
    init(factory: APODFactoryProtocol = APODFactory()) {
        self.factory = factory
    }
    
    func createAPODView() -> APODContentView<APODViewModel> {
        return factory.createAPODView()
    }
}
