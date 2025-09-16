import Foundation
import Combine
import Network

final class APODViewModel: APODViewModelProtocol {
    
    @Published private(set) var state: APODViewState = .idle
    
    private let useCase: APODUseCaseProtocol
    
    private var currentTask: Task<Void, Never>?
    
    init(useCase: APODUseCaseProtocol) {
        self.useCase = useCase
    }
    
    func handle(_ action: APODAction) {
        switch action {
        case .loadAPOD(let date):
            loadAPOD(date: date)
        case .loadRandomAPOD:
            loadRandomAPOD()
        case .clearError:
            clearError()
        case .refresh:
            refresh()
        }
    }
    
    private func loadAPOD(date: String) {
        executeAsyncOperation { [weak self] in
            guard let self = self else { throw RequestError.networkError("Service unavailable") }
            return try await self.useCase.fetchAPOD(for: date)
        }
    }
    
    private func loadRandomAPOD() {
        executeAsyncOperation { [weak self] in
            guard let self = self else { throw RequestError.networkError("Service unavailable") }
            let entities = try await self.useCase.fetchRandomAPOD(count: 1)
            guard let first = entities.first else {
                throw RequestError.invalidResponse
            }
            return first
        }
    }
    
    private func refresh() {
        loadRandomAPOD()
    }
    
    private func clearError() {
        state = .idle
    }
    
    private func executeAsyncOperation<T>(operation: @escaping () async throws -> T) {
        cancelCurrentTask()
        
        currentTask = Task { [weak self] in
            guard let self = self else { return }
            
            await MainActor.run {
                self.state = .loading
            }
            
            do {
                let result = try await operation()
                try Task.checkCancellation()
                
                await MainActor.run {
                    if let apodResult = result as? APODEntity {
                        self.state = .success(apodResult)
                    }
                }
                
            } catch is CancellationError {
                await MainActor.run {
                    self.state = .idle
                }
            } catch {
                await MainActor.run {
                    self.state = .error(APODErrorModel(from: error))
                }
            }
        }
    }
    
    private func cancelCurrentTask() {
        currentTask?.cancel()
        currentTask = nil
    }
    
    deinit {
        currentTask?.cancel()
    }
}

