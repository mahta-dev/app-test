import Foundation
import Combine
import Network

final class APODViewModel: APODViewModelProtocol {
    
    @Published private(set) var apod: APODResponse?
    @Published private(set) var isLoading = false
    @Published private(set) var error: APODErrorModel?
    
    private let apodService: APODServiceProtocol
    
    private var currentTask: Task<Void, Never>?
    
    var isEmpty: Bool { apod == nil }
    
    init(apodService: APODServiceProtocol) {
        self.apodService = apodService
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
            return try await self.apodService.fetchAPOD(date: date)
        }
    }
    
    private func loadRandomAPOD() {
        executeAsyncOperation { [weak self] in
            guard let self = self else { throw RequestError.networkError("Service unavailable") }
            let responses = try await self.apodService.fetchRandomAPOD(count: 1)
            guard let first = responses.first else {
                throw RequestError.invalidResponse
            }
            return first
        }
    }
    
    private func refresh() {
        loadRandomAPOD()
    }
    
    private func clearError() {
        error = nil
    }
    
    private func executeAsyncOperation<T>(operation: @escaping () async throws -> T) {
        cancelCurrentTask()
        
        currentTask = Task { [weak self] in
            guard let self = self else { return }
            
            await MainActor.run {
                self.isLoading = true
                self.error = nil
            }
            
            do {
                let result = try await operation()
                try Task.checkCancellation()
                
                await MainActor.run {
                    if let apodResult = result as? APODResponse {
                        self.apod = apodResult
                    }
                    self.isLoading = false
                }
                
            } catch is CancellationError {
                await MainActor.run {
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.apod = nil
                    self.error = APODErrorModel(from: error)
                    self.isLoading = false
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

